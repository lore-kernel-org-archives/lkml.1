Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbYAGDgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbYAGDgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 22:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbYAGDgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 22:36:23 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:1517 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbYAGDgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 22:36:22 -0500
From: Roman Zippel <zippel@linux-m68k.org>
To: "Ph. Marek" <philipp.marek@bmlv.gv.at>
Subject: Re: "mconf" and help texts
Date: Mon, 7 Jan 2008 04:31:24 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200801031115.48859.philipp.marek@bmlv.gv.at>
In-Reply-To: <200801031115.48859.philipp.marek@bmlv.gv.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801070431.25688.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 3. January 2008, Ph. Marek wrote:

> So I took a look at "Help", and saw that blob:
>
>   Selected by: NETFILTER_XT_TARGET_CONNMARK && NET && INET && NETFILTER &&
>      NETFILTER_XTABLES && (IP_NF_MANGLE || IP6_NF_MANGLE) && NF_CONNTRACK
> || NETFILTER_XT_MATCH_CONNMARK && NET && INET && NETFILTER &&
>      NETFILTER_XTABLES && NF_CONNTRACK || IP_NF_TARGET_CLUSTERIP && NET &&
>      INET && NETFILTER && IP_NF_MANGLE && EXPERIMENTAL && NF_CONNTRACK_IPV4
>
> That is a _bit_ unreadable.

What you see here is the internal representation of the select expression. To 
make it more easily readable, you could just cut off everything between && 
and || (it's the dependency of the symbol which does the select, the one 
before &&).
The readable expression could be generated when needed, but it might be easier 
to just generate at the same time as the full expression (in menu_finalize).

> As a side-node - I cannot get xconfig to work (pkg-config);

Why exactly? What's the error message?

> is there some 
> way in menuconfig to see why some config option is disallowed? The location
> tree shows some data ("-> Networking support (NET [=y])"), but not for all
> dependencies.

I don't quite understand. The dependency for option itself is above the 
location tree and the for dependencies of the dependencies you have to look 
at their individual info.

> [Does xconfig allow enabling them while seeing this option?] 

Only if you enable the missing dependency. This is insofar a little easier as 
they are linked if you enable the deubg info, so the prompt may be a little 
easier to find.

bye, Roman
