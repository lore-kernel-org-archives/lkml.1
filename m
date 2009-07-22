Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZGVWPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZGVWPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbZGVWPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:15:10 -0400
Received: from n20.bullet.mail.mud.yahoo.com ([68.142.206.147]:43437 "HELO
	n20.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753299AbZGVWPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:15:09 -0400
X-Yahoo-Newman-Id: 829137.95495.bm@omp420.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=b1uVvQdiUcz82QGHPzkTyXpvk+3RQv4/5oR+YpOwaXm2/Rl4VcaPVpN1Qk+rmJO7fYznCzjwA+zgBY85cdCsBn0ILUG11t/K6eeCNAreJqUsOmsa4mt8pkouqAFhoLnxIQDkVoQ00cuKjw10a3fo4jkqZnUfP0JVtIJOxYfuBIk=  ;
X-YMail-OSG: MAvmrSMVM1ldmgWDITJCJr2m3SCkqi2M55v6GAeUFAC9X_OxgcpyKONjjXEDCr1F51UIOTdOoNi4eZqkzd8tznsi6fVrJ.4_j1FsH_V9R_kKJ9pesvVWCjs_CkWUT4XNal_eK61y_sqFRmPwHC2b60hJKEpo8Xzu1OiV9Sn6k8xrJA0tBYFbSrmTfBgLuVPlhiukbF7RAn67FerPmB4A4omAxXTHUlpjqmk6JPqupXfSqi3I.5jOmJogXsXzzkyDAff.scT9haGWyMjr_GkutZ_88VZd2qd6mIVeNnTv00tu3yrmojB7
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Date: Wed, 22 Jul 2009 15:15:06 -0700
User-Agent: KMail/1.9.10
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       Daniel Ribeiro <drwyrm@gmail.com>
References: <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com> <alpine.LFD.2.00.0907222226270.2813@localhost.localdomain> <d6200be20907221457r4e2f6d29g57146586fd13776a@mail.gmail.com>
In-Reply-To: <d6200be20907221457r4e2f6d29g57146586fd13776a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907221515.07835.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 July 2009, Arve Hjønnevåg wrote:
> It would also be useful to mask an edge triggered interrupt until the
> thread handler has finished. The touchscreen on the G1 is connected to
> an edge triggered interrupt, and the touchscreen may toggle the
> interrupt line while reading its registers.

To clarify:  if it does toggle, do you want that event to be
queued up so the IRQ is re-issued -- or not?  That "oneshot"
mechanism does some of that, though it's for level triggers.

Parts of that might be appropriate to handle in the threaded
IRQ handler itself.  It seems a bit device-specific.

- Dave

