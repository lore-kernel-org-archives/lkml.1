Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbZANDN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbZANDN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 22:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZANDNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 22:13:18 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57193 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZANDNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 22:13:18 -0500
Date: Wed, 14 Jan 2009 12:12:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [RFC][PATCH 4/4] cgroup-memcg fix frequent EBUSY at rmdir
Message-Id: <20090114121205.1bb913aa.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830901131905ie10e4bl5168ab7f337b27e1@mail.gmail.com>
References: <20090108182556.621e3ee6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090108183529.b4fd99f4.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901131848gf7f6996iead1276bc50753b8@mail.gmail.com>
	<20090114120044.2ecf13db.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901131905ie10e4bl5168ab7f337b27e1@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 19:05:35 -0800
Paul Menage <menage@google.com> wrote:

> On Tue, Jan 13, 2009 at 7:00 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > Hmm, add wait_queue to css and wake it up at css_put() ?
> >
> > like this ?
> > ==
> > __css_put()
> > {
> >        if (atomi_dec_return(&css->refcnt) == 1) {
> >                if (notify_on_release(cgrp) {
> >                        .....
> >                }
> >                if (someone_waiting_rmdir(css)) {
> >                        wake_up_him().
> >                }
> >        }
> > }
> 
> Yes, something like that. A system-wide wake queue is probably fine though.
> 
Ok, I'll try that.

-Kame

