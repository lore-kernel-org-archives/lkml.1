Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZGBCWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZGBCWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 22:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZGBCWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 22:22:42 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:62198 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbZGBCWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 22:22:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bPteEECUGLqmrZSEFXVnZbAugoere+J6ISf+MDskaw8mshTkuppE3p+dauMro2Y5lp
         q736zaYMPtTiGdOR/Mpt14NqHy+JQtCBTdL3d2Mm9EtPArH7aqlCl+74Kcn9Jj0flc5X
         7tZp3exCN+2VLLFb/FoxJi/PrDFw0zAkP22OY=
MIME-Version: 1.0
In-Reply-To: <20090629150123.43f79091.akpm@linux-foundation.org>
References: <20090619072212.6519.10915.sendpatchset@localhost.localdomain>
	 <20090629150123.43f79091.akpm@linux-foundation.org>
Date: Wed, 1 Jul 2009 22:22:45 -0400
X-Google-Sender-Auth: 4d19c111c1be8c28
Message-ID: <75b66ecd0907011922x1843c0d3g9c3bf6f686f981e2@mail.gmail.com>
Subject: Re: [Patch] sysctl: forbid too long numbers
From: Lee Revell <rlrevell@joe-job.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 6:01 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
> Or are they?  One could imagine a script which was tested and developed
> on a 64-bit system, which writes a >4G number into a pseudo file.  That
> script happens to work on 32-bit systems (it might not work _well_, but
> it'll work).  With this change, the write will fail on the 32-bit
> system and the entire application could bale out or something.
>
> I'm not saying that this is a reason to avoid making the change, but
> it's all a worry and needs consideration.

This would break at least one existing setup that I know of.  Consider
an environment where shmmax is set to the value the biggest server
needs (well over 4GB) on all database servers to simplify management.
This change would cause the database to fail on the old 32 bit servers
used for testing and QA.

Lee
