Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbZF3PC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbZF3PC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 11:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZF3PCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 11:02:49 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:65347 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZF3PCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 11:02:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=C+Y1SeQWSV7siePaRW3aUueLVUXDlO5jTOvMWJQMNTL2U+rJ9snp0tg7KX4jD87fP7
         31eWS6KhalW5pNIvDUD+LTG+aBRMetdhDCnBLZcJpp6xUJLLY0atfynQuQmYAhYlKxoN
         lHAxe8WN4Es8EtdO+RXhS+uZQzu97qbce5+Zk=
MIME-Version: 1.0
In-Reply-To: <20090629234035.12475.58493.stgit@localhost.localdomain>
References: <20090629234035.12475.58493.stgit@localhost.localdomain>
Date: Tue, 30 Jun 2009 10:02:49 -0500
X-Google-Sender-Auth: 9e7d83686453b518
Message-ID: <ed82fe3e0906300802h2bcfb651q5f8a37423307e7ff@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Fix spin_event_timeout() to be robust over 
	context switches
From: Timur Tabi <timur@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, jonsmirl@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 6:40 PM, Grant Likely<grant.likely@secretlab.ca> wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
>
> Current implementation of spin_event_timeout can be interrupted by an
> IRQ or context switch after testing the condition, but before checking
> the timeout.  This can cause the loop to report a timeout when the
> condition actually became true in the middle.
>
> This patch adds one final check of the condition upon exit of the loop
> if the last test of the condition was still false.
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Timur Tabi <timur@freescale.com>

Ben, please pick this up for the next rc of 2.6.31.

-- 
Timur Tabi
Linux kernel developer at Freescale
