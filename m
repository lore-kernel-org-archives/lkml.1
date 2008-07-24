Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbYGXAYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbYGXAYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 20:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbYGXAYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 20:24:12 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:47123 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbYGXAYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 20:24:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=U1z/n5oN3meGzqB+zifQ57q3SRWqrr+a4Qm7/du1YIKuebRHZYoVtVGh9OvZjUzf52
         L2Xo6r9Cpyp/7UaA1qfM/QrLkvdkkyiSoIQowAGmN1wxaY6aBmO+BQcqosgIq0rwzIlJ
         Gb2qREWFKErxY5lRKHbMcRKATYUlVbISCkcB8=
Subject: Re: [PATCH] cifs: avoid mixing bool and le16
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <524f69650807231719y33e96d02y7b04d1115620aa1d@mail.gmail.com>
References: <1216857138.30386.33.camel@brick>
	 <524f69650807231719y33e96d02y7b04d1115620aa1d@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 23 Jul 2008 17:24:11 -0700
Message-Id: <1216859051.30386.40.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-23 at 19:19 -0500, Steve French wrote:
> Seems like a cast to bool or an "if ...else" would be clearer than using !!
> By the way I don't see this warning - is it a newer compiler warning?
> 

Sorry, sometimes I forget to say sparse warning.  This is with
__CHECK_ENDIAN__ as well.

Would you prefer:
	if (pSMBr->hdr.Flags2 & SMBFLG2_UNICODE)
		is_unicode = true;
	else
		is_unicode = false;

Instead?

Harvey

