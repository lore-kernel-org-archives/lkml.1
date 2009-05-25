Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZEYKPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZEYKPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 06:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZEYKO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 06:14:58 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:40123 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752196AbZEYKO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 06:14:58 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200905251014.n4PAEi0k027544@mercury.physics.adelaide.edu.au>
Subject: Re: Realtek 8168D: no active link (2.6.29.2)
To: romieu@fr.zoreil.com (Francois Romieu)
Date: Mon, 25 May 2009 19:44:44 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       dave@thedillows.org (David Dillow), linux-kernel@vger.kernel.org,
       edward_hsu@realtek.com.tw (Edward Hsu)
In-Reply-To: <20090519213213.GA6377@electric-eye.fr.zoreil.com> from "Francois Romieu" at May 19, 2009 11:32:13 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Sorry for the delay in getting this done.

> Jonathan Woithe <jwoithe@physics.adelaide.edu.au> :
> [...]
> > As I mentioned, if there are other tests you want me to do just drop me a
> > line.
> 
> You may see if you can force the link settings with the patches #2 and #3 at
> http://userweb.kernel.org/~romieu/r8169/2.6.30-rc6/20090519/

As far as I can tell, with these 3 patches applied against 2.6.30-rc6 I can
force the link settings:

  ethtool -s eth0 autoneg off speed 10
    - 10 Mbps speed set

  ethtool -s eth0 autoneg off speed 100
    - 100 Mbps speed achieved

  ethtool -s eth0 autoneg on speed 1000
    - 1000 Mbps speed attained

The duplex setting might not be having an effect though since my switch's
FDx (full duplex) LED was extinguished for both the 10 and 100 Mbps cases
above.  Explicitly setting the duplex flag using

  ethtool -s eth0 autoneg off speed 100 duplex full

didn't make any difference - the FDx LED remained off.  For completeness I
also tried

  ethtool -s eth0 autoneg off speed 100 duplex half

and this caused no change compared to the "duplex full" case above. 
Restoring autoneg made the FDx LED return (along with 1000 Mbps speed).

Regards
  jonathan
