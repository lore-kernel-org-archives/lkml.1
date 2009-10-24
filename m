Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbZJXN0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbZJXN0t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 09:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZJXN0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 09:26:48 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:41472 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbZJXN0s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 09:26:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ffQ8RiSNRIxMOc/f92UPMbR9eZytjVPLPK+Vk6kc6AbjMW/UFsagocD15nzciSZCcx
         fPVW72CRoLr36fNztwaVzMLYanS1BHy/LuM42dZgrm1MPINHjP/UmlR/2VLXxyWdl8Fv
         vsumlB5RFjcnRWnD3i9KJ5ksUKa0qk5y8iJ1s=
MIME-Version: 1.0
In-Reply-To: <20091024083031.GB20575@elte.hu>
References: <1256330234-14079-1-git-send-email-marti@juffo.org> 
	<20091023210231.GC8356@elte.hu> <1256334501-15755-1-git-send-email-marti@juffo.org> 
	<193b0f820910231807t35f8b462r1f92e28492b780e2@mail.gmail.com> 
	<20091024083031.GB20575@elte.hu>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Sat, 24 Oct 2009 11:26:31 -0200
Message-ID: <193b0f820910240626m1567190cqc40930542453319d@mail.gmail.com>
Subject: Re: [PATCH] perf tools: add compatibility with libelf 0.8 and 
	autodetect
To: Ingo Molnar <mingo@elte.hu>
Cc: Marti Raudsepp <marti@juffo.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 24, 2009 at 06:30, Ingo Molnar <mingo@elte.hu> wrote:
> I.e. something like this:
>
> /*
>  * libelf 0.8 and earlier do not support ELF_C_READ_MMAP;
>  * for newer versions we can use mmap to reduce memory usage:
>  */
> #ifndef ELF_C_READ_MMAP
> # define PERF_ELF_C_READ_MMAP ELF_C_READ
> #endif

In this case you should define PERF_ELF_C_READ_MMAP as ELF_C_READ_MMAP
when using elftutils:
#ifndef ELF_C_READ_MMAP
# define PERF_ELF_C_READ_MMAP ELF_C_READ
#else
# define PERF_ELF_C_READ_MMAP ELF_C_READ_MMAP
#endif

and change all places to use PERF_ELF_C_READ_MMAP


I think the comment is wrong. I downloaded the latest version of
libelf, i.e. 0.8.12 at http://www.mr511.de/software/english.html, and
there's no support to ELF_C_READ_MMAP. It's a elfutils' feature only.
