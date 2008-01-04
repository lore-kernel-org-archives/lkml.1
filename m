Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbYADNSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbYADNSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbYADNS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:18:28 -0500
Received: from nz-out-0506.google.com ([64.233.162.224]:54124 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbYADNST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:18:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i74id9KKHM4jMJ3eKDhmqyp9bqGa+GLC1XRVLtViIE3aFEr/hqcBaUAe9INmVTkhb9QufqSHYZZtFxZujrApN6xX7hkTeac0/ZPpNk3dNO1R7qNB736sG7TDFyoC94iNWFqQNN8sDJ4a8jhn1WJIDI6Ja7FqojACmX+qRYRqYbU=
Message-ID: <4d8e3fd30801040518q4e115efcoc8967e516fa365f1@mail.gmail.com>
Date: Fri, 4 Jan 2008 14:18:17 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] This patch to profile.c fixes a few errors reported by checkpatch.pl
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080104130702.GC20981@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080104003253.7a7309d8@paolo-desktop>
	 <20080104083442.GD22803@elte.hu>
	 <4d8e3fd30801040318q2e3be951rbf517f7d6022ae04@mail.gmail.com>
	 <20080104130702.GC20981@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 4, 2008 2:07 PM, Ingo Molnar <mingo@elte.hu> wrote:
[...]
> > That said, the errors reported by checkpatch.pl are now:
> > paolo@paolo-desktop:~/linux-2.6/kernel$ ../scripts/checkpatch.pl
> > --terse --file profile.c |grep ERROR
> > profile.c:128: ERROR: "foo * bar" should be "foo *bar"
> > I just forgot to fix it, very trivial. Will do in a minute.
> >
> > profile.c:460: ERROR: do not use assignment in if condition (+  if
> > (!(entry = create_proc_entry("XXXXXXXXXXXXX", 0600, root_irq_dir))))
> > profile.c:594: ERROR: do not use assignment in if condition (+  if
> > (!(entry = create_proc_entry("XXXXXXX", S_IWUSR | S_IRUGO, NULL))))
> > Here I need an hint ( or an example) about how to fix these two errors :-)
>
> transform:
>
>   if (!(x = y))
>
> to:
>
>   x = y
>   if (!x)
>
> i.e. take the implicit assignment out of the condition. (it's easy to
> mistake it for '==' while reviewing the code and forgetting about the
> assignment's side-effect)

OK, thanks.

Is the following correct?

Before:
 if (!(entry = create_proc_entry("prof_cpu_mask", 0600, root_irq_dir)))

After:
entry = create_proc_entry("prof_cpu_mask", 0600, root_irq_dir)
if (!entry)

BTW, how can i compile only the profile.c file?
I would like to verify that my changes (now I'm at total: 2 errors, 1
warnings, 599 lines checked)
doesn't impact on the compiled code?

Thanks.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
