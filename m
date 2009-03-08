Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbZCHVFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbZCHVFN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 17:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZCHVFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 17:05:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34788 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbZCHVE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 17:04:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: 2.6.29-rc breaks STD using Intel 945
Date: Sun, 8 Mar 2009 22:04:45 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, LKML <linux-kernel@vger.kernel.org>,
       David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200903042020.57671.eike-kernel@sf-tec.de> <20090305125529.GB16693@silver.sucs.org> <200903081902.23998.eike-kernel@sf-tec.de>
In-Reply-To: <200903081902.23998.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903082204.45715.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 March 2009, Rolf Eike Beer wrote:
> Sitsofe Wheeler wrote:
> > On Wed, Mar 04, 2009 at 08:20:56PM +0100, Rolf Eike Beer wrote:
> > > I tested several snapshots post 2.6.28 and all of them show one severe
> > > problem: resume from disk is not always successful. Only about 50% of the
> > > resume attempts work, in the other cases I just get a completely black
> > > screen, can't switch to text console or anything. What I often get is a
> > > line like this in the logs directly before suspend:
> >
> > Does this happen when X hasn't been started and you suspend to disk then
> > resume?
> 
> I tested several times without X, with X running only in backgroud (i.e. me 
> initiating the suspend from console) and from xdm only. Never it froze. That 
> leads me to the conclusion that it is probably related to composite. I'm 
> using KDE 4.2.

That's most probably correct.

> Here is the corresponding section from Xorg.conf:
> 
> Section "Device"
>   BoardName    "945 GM"
>   BusID        "0:2:0"
>   Driver       "intel"
>   Identifier   "Device[0]"
>   Option       "NoDDC"
>   Option       "usevnc" "no"
>   VendorName   "Intel"
>   Option      "ExaNoComposite" "false"
>   Option      "MigrationHeuristic" "greedy"
> EndSection

It may be related to freedesktop bug at
https://bugs.freedesktop.org/show_bug.cgi?id=17638

Thanks,
Rafael
