Return-Path: <linux-kernel-owner+w=401wt.eu-S932323AbXF1XyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbXF1XyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761156AbXF1XyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:54:14 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:64306 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759461AbXF1XyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:54:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JbOHMRkVaIM5m8ZTvWxZEmVsuXlPkdjd3Qzo5PK0kkhCZd77e/Fb4pSEPSixIPOIOnF/aYw2jn/bmbwqWnVf98tEsRJ5rLWM5yvObJsEBHPpY9S8xtj1xOTokvrXH3Y/TFec/K8VnsNg42wQJ6v4gn38yft6BasayFM5tAYzMfc=
Message-ID: <8bd0f97a0706281654r37a3e10cja74a359bf7d425f@mail.gmail.com>
Date: Thu, 28 Jun 2007 18:54:12 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Kyle McMartin" <kyle@mcmartin.ca>
Subject: Re: [PATCH] Info dump on Oops or panic()
Cc: "Joshua Wise" <jwise@google.com>, linux-kernel@vger.kernel.org,
       akpm@google.com, thockin@google.com, mikew@google.com,
       masouds@google.com
In-Reply-To: <20070628221835.GI2784@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706281502350.617@internets.corp.google.com>
	 <20070628221835.GI2784@fattire.cabal.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/07, Kyle McMartin <kyle@mcmartin.ca> wrote:
> On Thu, Jun 28, 2007 at 03:05:56PM -0700, Joshua Wise wrote:
> > --- a/arch/x86_64/kernel/process.c
> > +++ b/arch/x86_64/kernel/process.c
> > @@ -356,6 +356,7 @@ void show_regs(struct pt_regs *regs)
> >       printk("CPU %d:", smp_processor_id());
> >       __show_regs(regs);
> >       show_trace(NULL, regs, (void *)(regs + 1));
> > +     atomic_notifier_call_chain(&info_dumper_list, 0, NULL);
> >  }
> >
>
> woah woah woah. This could push critical bits of the register dump or
> stacktrace off the screen... Barring any other problems with the patch,
> this should probably be dumped in the oops header, not trailing it where
> it could hide critical debugging info.

on the flip side, poorly written chained funcs could oops thus
preventing the good info (like stacktrace) from being shown ...
-mike
