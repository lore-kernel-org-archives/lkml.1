Return-Path: <linux-kernel-owner+w=401wt.eu-S1759043AbZELAqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043AbZELAqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbZELAqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 20:46:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:32806 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613AbZELAq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 20:46:29 -0400
Date: Tue, 12 May 2009 09:44:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] memcg fix stale swap cache account leak v6
Message-Id: <20090512094459.79b59cee.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090511122711.GF13954@elte.hu>
References: <20090508140528.c34ae712.kamezawa.hiroyu@jp.fujitsu.com>
	<20090508140910.bb07f5c6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090508113820.GL11596@elte.hu>
	<a369eb83999c47faac2bc894c2f43a9d.squirrel@webmail-b.css.fujitsu.com>
	<20090511122711.GF13954@elte.hu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 14:27:11 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > > Isnt the right solution to have a better LRU that is aware of 
> > > this, instead of polling around in the hope of cleaning up stale 
> > > entries?
> >
> > I tried to modify LRU in the last month but I found it's 
> > difficult.
> 
> But your patch makes such a correct solution even more difficult to 
> achieve, so in that sense it might be a step backwards, right?
> 
Hmm...maybe or not. This leak comes from laziness of LRU and trylock() swap handling
for avoiding contentions. So, even if we addd new LRU, we need some trick to do
synchronous work.

Anyway, I'll use Nishimura's one, which is simple.
This is a bug fix and I don't want a patch which needs a half year testing ;)

Thanks,
-Kame

