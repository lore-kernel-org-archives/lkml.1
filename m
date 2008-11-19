Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbYKSXgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbYKSXgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 18:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYKSXgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 18:36:03 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:19041 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYKSXgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 18:36:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=BNtXUhCo2OIq73mOdnzIsFSSB3pt0LGokjd7uzBsNXqKl98ylh3mf9KkdV2NYxcyk8
         S1AZUjDemcl96ZCY9g7PNsVRxzXqDMrqcgvMHdK6xATg4SeEykItl/XgkpNYm5HIqrie
         nxjKQRY7SjuwwwDcRsdaJ9pLz4kLSQgxgz+CU=
From: Eric Lacombe <goretux@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [x86] do_arch_prctl
Date: Thu, 20 Nov 2008 00:35:57 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.5; KDE/4.1.3; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <200811181835.07360.goretux@gmail.com> <200811191023.16358.goretux@gmail.com> <49247FC6.8080201@goop.org>
In-Reply-To: <49247FC6.8080201@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811200035.57509.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your answer, I've got one last question ;)
In the ARCH_GET_GS, can you explain the line 834 to 838?

In fact, at first sight I thought that just the line 836 was sufficient, but I 
obviously miss the case where MSR_KERNEL_GS_BASE does not reflect the value 
requested, hence my question.

828 case ARCH_GET_GS: {
829                 unsigned long base;
830                 unsigned gsindex;
831                 if (task->thread.gsindex == GS_TLS_SEL)
832                         base = read_32bit_tls(task, GS_TLS);
833                 else if (doit) {
834                         asm("movl %%gs,%0" : "=r" (gsindex));
835                         if (gsindex)
836                                 rdmsrl(MSR_KERNEL_GS_BASE, base);
837                         else
838                                 base = task->thread.gs;
839                 }
840                 else
841                         base = task->thread.gs;

Thanks,

	Eric


