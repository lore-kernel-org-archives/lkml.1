Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbYDACXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbYDACXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 22:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYDACXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 22:23:10 -0400
Received: from testure.choralone.org ([194.9.77.134]:42781 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbYDACXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 22:23:09 -0400
Date: Mon, 31 Mar 2008 22:22:48 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, rusty@rustcorp.com.au,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: wish: build time warning for missing MODULE_LICENSE
Message-ID: <20080401022247.GA8383@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
	rusty@rustcorp.com.au, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080330180119.GC1575@cs181133002.pp.htv.fi> <20080330190430.GD19733@uranus.ravnborg.org> <20080330203417.GA7607@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080330203417.GA7607@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 11:34:17PM +0300, Adrian Bunk wrote:
 > On Sun, Mar 30, 2008 at 09:04:30PM +0200, Sam Ravnborg wrote:
 > > On Sun, Mar 30, 2008 at 09:01:19PM +0300, Adrian Bunk wrote:
 > > > I just fixed a bug where I had accidentally removed a MODULE_LICENSE() 
 > > > from a file.
 > > > 
 > > > The problem is that such bugs are currently not discovered until someone 
 > > > actually runs a kernel with this module loaded.
 > > > 
 > > > Could we get a build time warning/error for a missing MODULE_LICENSE?
 > > 
 > > Is it something as simple as this you are after?
 > > [My dev box is dead atm so I have not done a kernel build
 > > with this, only a single module].
 > 
 > Thanks, it seems to work - and I'm currently working on fixing the bugs 
 > it catches.
 > 
 > Considering that these are trivial to fix I'd even suggest a fatal() 
 > instead of the warn() for making them obvious for everyone doing build 
 > testing.
 
In the Fedora kernel specfile, we have something to catch this at build time.
Relevant pieces are (munged a bit for clarity) ..

    find . -name "*.ko" -type f >modnames

    while read i
    do
      echo -n "$i " >> modinfo
      /sbin/modinfo -l $i >> modinfo
    done < modnames

    egrep -v \
          'GPL( v2)?$|Dual BSD/GPL$|Dual MPL/GPL$|GPL and additional rights$' \
          modinfo && exit 1

This hasn't been triggering though, so either it stopped working at some point,
or we don't build the module you mention.  Which was it out of curiosity ?
Or was your slip-up an -mm only thing?

	Dave

-- 
http://www.codemonkey.org.uk
