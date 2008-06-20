Return-Path: <linux-kernel-owner+w=401wt.eu-S1760564AbYFTUz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564AbYFTUz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbYFTUzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:55:15 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50583 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754704AbYFTUzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:55:14 -0400
Date: Fri, 20 Jun 2008 13:55:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Mike Travis <travis@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
In-Reply-To: <m1skv7onvh.fsf@frodo.ebiederm.org>
Message-ID: <Pine.LNX.4.64.0806201354450.16534@schroedinger.engr.sgi.com>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
 <20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com> <485947A8.8060801@goop.org>
 <4859511E.5050605@sgi.com> <48596315.6020104@goop.org> <48596893.4040908@sgi.com>
 <485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org> <485AC120.6010202@sgi.com>
 <485AC5D4.6040302@goop.org> <485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com>
 <485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com> <485ADC73.60009@goop.org>
 <485BDB04.4090709@sgi.com> <485BE80E.10209@goop.org>
 <Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>
 <485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com> <m1skv7onvh.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008, Eric W. Biederman wrote:

> at __per_coup_load.  But it is absolute Ugh.  
> 
> It might be worth saying something like.
> .data.percpu.start : AT(.data.percpu.dummy - LOAD_OFFSET) {
> 	DATA(0)                   
> 	. = ALIGN(align);
>         __per_cpu_load = . ;                   
> }
> To make __per_cpu_load a relative symbol. ld has a bad habit of taking
> symbols out of empty sections and making them absolute.  Which is why
> I added the DATA(0).
> 
> Still I don't think that would be the 64bit problem.

Ahh.. Good idea. I had a long fight with the loader before it did the 
right thing.

