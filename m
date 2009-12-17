Return-Path: <linux-kernel-owner+w=401wt.eu-S1765034AbZLQR0C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765034AbZLQR0C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:26:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764995AbZLQR0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:26:01 -0500
Received: from outbound-mail-317.bluehost.com ([67.222.54.10]:42242 "HELO
	outbound-mail-317.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759518AbZLQR0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:26:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=sfP/ANrzyWEDnDASeIEGCCD2cioVtSLObWc+BRAZYFywmuH1lVaovpk3m2hr3+phX+RdzpEzfjJSAvLEglxLnXEKr0yRYF5utrqPVuhq7u0Z+PgVnepEc/3wB8NJHA2W;
Date: Thu, 17 Dec 2009 09:25:23 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: keithp@keithp.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
       linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes
 when ..."
Message-ID: <20091217092523.755ecf29@jbarnes-piketon>
In-Reply-To: <200912162241.27591.arnd@arndb.de>
References: <200912071830.14697.arnd@arndb.de>
	<20091216133005.0e822950@jbarnes-piketon>
	<200912162136.36458.arnd@arndb.de>
	<200912162241.27591.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009 22:41:27 +0000
Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 16 December 2009 21:36:36 Arnd Bergmann wrote:
> > On Wednesday 16 December 2009 21:30:05 Jesse Barnes wrote:
> > > But you're sure powersave=0 was solid?  Hmm...
> > 
> > It's hard to be sure when it sometimes takes a day before a
> > broken version crashes. I can keep running this kernel with and
> > without powersave=0 some more and tell you if it stays reproducible.
> 
> Now it has crashed with i915.powersave=0 plus your patch as well
> (latest 2.6.32 git), indicating that there is something else wrong
> with the original 652c393a33 patch.

It does very little else that should affect things.  You're sure
reverting the commit makes things ok?

Other potential problems:
  - clock gating (the call to intel_init_clock_gating)
  - the actual mark_busy stuff itself (calls to intel_mark_busy)
  - intel_idle_update (but powersave=0 should prevent that)

If you want to keep testing you could try removing those calls...

-- 
Jesse Barnes, Intel Open Source Technology Center
