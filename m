Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbZDWMeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbZDWMeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZDWMeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:34:03 -0400
Received: from fornax.pixelized.ch ([88.198.8.169]:51386 "EHLO
	fornax.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbZDWMeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:34:02 -0400
Message-ID: <49F0602C.1060605@cateee.net>
Date: Thu, 23 Apr 2009 14:33:48 +0200
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Rafael Lotufo <rlotufo@swen.uwaterloo.ca>
CC: linux-kernel@vger.kernel.org, Kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: Tool support for Kconfig
References: <DC736A60-0CD8-44BA-92B6-653CF56F6DB1@gsd.uwaterloo.ca>
In-Reply-To: <DC736A60-0CD8-44BA-92B6-653CF56F6DB1@gsd.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC also to kbuild list]

Rafael Lotufo wrote:
> We currently see the Linux kernel configuration options as a very rich 
> real-world feature model,

But also broken and it lack a lot of useful features.

> and it has been our subject
> of investigation since last January. Our current efforts have been to 
> create a reasoning tool for the Kconfig options, something that
> could help in finding recursive dependencies, configuration options that 
> cannot be selected, and even tools that would facilitate
> configuring the Linux kernel, like resolving dependencies for a wanted 
> configuration option that cannot be currently selected
> due to its dependencies. Furthermore, the reasoning tool can compute 
> semantic diffs, intersections, unions, and slices of Kconfig
> specifications.
> 
> We would be interested to receive input from interested Linux kernel 
> developers regarding their experience
> with modifying Kconfig files. Would a tool for analyzing and comparing 
> Kconfig files be useful?
> What questions one typically has to answer when evolving Kconfig files? 
> Are there any frequent problems
> or mistakes?

the Kconfig has a big real problem: linear order of dependencies,
i.e. dependencies should be defined before use point.  This is not
a requirement of language, but with current interfaces would be very
impractical to find new options in past branches. But on the other hand,
in some cases is very annoying. (Lately I configured a new machine, starting
from distribution config. In this case I needed to go from bottom to
top of tree, in order to remove almost every (unneded) feature.

So a check that warn about such cases would be nice. This would resolve
also the recursion problem.
But also a better way to handle dependencies (in user interface)
would be nice, like our package managers:
- removing a CONFIG (showing all dependencies before confirmation)
   [which is not yet possible]
- adding a know CONFIG, which could be hidden.
   Actually we can ask for dependencies with search '/' command, but
   also allowing to select the dependencies (like in our package manager)
   would be nice.

Note: such features could make "SELECT" obsolete.

Know problems?
I don't know. Usually new driver use copy paste, so without
big problems. The syntax is pretty simple.

There was some confusion about dependency handling (logical
operators with ternary values n/m/y)

SELECT is sometime used incorrectly (style/design, not in
semantic layer)

config menu can be defined several time. This is a nice feature,
but also a source of possible problems. I think normally it is
OK on same file and on incompatible area (e.g. on different
architectures). I think all other cases should be errors.

Hidden (always invalid dependencies) CONFIG item are interesting.

ciao
	cate

> 
> We would very much appreciate any input on this subject.
> 
> Thank you very much for you attention,
> 

