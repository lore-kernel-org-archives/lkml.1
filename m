Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYLXDw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYLXDw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 22:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYLXDwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 22:52:19 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:23432 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751392AbYLXDwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 22:52:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IFs8GzU/m/laRhNzvb1OUA1+Y233qvQ4zwjDzDksjG3rnEuFVdoeyM68hU+ALrF6qJ1PkHSAFJEXHq1WKXtNkz/xSOeuXx1W4vTSB9zw8/MlJZ96tGqSeN+opmRgLWViXUWtKrvjsJnUNN39n98J2ABjOFKD6/AbVnM/W9HyeN8=  ;
X-YMail-OSG: IyTuJJsVM1kdSQzseloqwpWlyYXpMEZ9zYBL5m7OV7slWwHDdMt4Gjmz20wxcCL4GbA8lN11XgEBWR_OzzLJrnP3H.fURROOE4V9wUcLWdyA2QJAMOmJ0GJr7d82iy2FrOmqqZKej2h6jZM9quJd1_3legibdxyK2hNIl2tYJoR_r4VsVBsjhi2MjTgS
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: me@felipebalbi.com
Subject: Re: [PATCH] musb: fix DaVinci build again
Date: Tue, 23 Dec 2008 19:52:15 -0800
User-Agent: KMail/1.9.10
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, gregkh@suse.de,
       felipe.balbi@nokia.com, davinci-linux-open-source@linux.davincidsp.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200812072341.50012.sshtylyov@ru.mvista.com> <200812231707.48195.david-b@pacbell.net> <20081224022757.GA10240@frodo>
In-Reply-To: <20081224022757.GA10240@frodo>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200812231952.16171.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 December 2008, Felipe Balbi wrote:
> >  #include <linux/gpio.h>
> > +#include <linux/gpio.h>
> 
> you're including <linux/gpio.h> twice.

Yeah, I suppose I just edited the patch to
delete segments that *did* get merged.  It
looks like that change to <linux/gpio.h> got
included, and "patch" didn't complain ...
leaving the puzzle of just why the *rest* of
that pre-2.6.27 build fix still hasn't merged.

A double inclusion is a minor-but-harmless
annoyance.  Those <asm/arch/...> ==> <mach/...>
header changes were mostly merged by 2.6.27-rc2,
but ones for this particular file got stripped
out.  More than a small bit puzzling; I can
understand patches getting dropped or lost,
but not getting mangled like that.

When I verify that I have a kernel booting
on the DM6446 EVM in mainline, I'll resend
both of the patches.  They are IMO overdue
to merge.

