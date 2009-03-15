Return-Path: <linux-kernel-owner+w=401wt.eu-S1759072AbZCOKVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072AbZCOKVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 06:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbZCOKVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 06:21:45 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:35298 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbZCOKVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 06:21:45 -0400
Date: Sun, 15 Mar 2009 11:23:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>
Subject: kconfig - fix randconfig
Message-ID: <20090315102341.GA6051@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kconfig failed to generate random values for choice values in
a choice block thus limiting the effect of builds based on randconfig
generated configs.

To test this I used this small config:

config MOD
	def_bool n
	option modules

choice CHOICE
        prompt "ABCD Choice"
        default A

config A
        tristate "A"

config B
        tristate "B"

config C
        tristate "C"

config D
        tristate "D"

endchoice

With the fix applied we now distribute the values more or
less even among the choice symbols.
And if MOD is enabled then we have several entries enabled.

Furhtermore calling randconfig several times in row made it
generate the same config as it used a second based seed.

Two patches follows - they are also at kfixes.git

	Sam
