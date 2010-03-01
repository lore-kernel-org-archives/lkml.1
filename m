Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab0CAU3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 15:29:41 -0500
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:53128 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748Ab0CAU3k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 15:29:40 -0500
From: Frans Pop <elendil@planet.nl>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH RFC] kconfig: place git SHA1 in .config output if in git tree
Date: Mon, 1 Mar 2010 21:29:35 +0100
User-Agent: KMail/1.9.9
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, mingo@elte.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
References: <20100301042249.GA12289@linux.vnet.ibm.com> <201003011753.34299.elendil@planet.nl> <20100301181616.GD6758@linux.vnet.ibm.com>
In-Reply-To: <20100301181616.GD6758@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201003012129.36937.elendil@planet.nl>
X-OriginalArrivalTime: 01 Mar 2010 20:29:37.0220 (UTC) FILETIME=[E973A040:01CAB97D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 March 2010, Paul E. McKenney wrote:
> Hmmm...  In that case, it won't find the scripts/setlocalversion script,
> either.  Unless you have the git tree on your $PATH, which seems
> unlikely.  So I can just check for popen() failure and take corrective
> action.

It doesn't work for me yet, but I don't see why not. It does work when I do 
e.g. a 'make defconfig' in the current directory, but not when I set 
KBUILD_OUTPUT.

It's probably easiest if you try to debug it yourself. It's as simple as:
$ mkdir /tmp/kbuild
$ KBUILD_OUTPUT=/tmp/kbuild make defconfig


One other thing. I wonder if this implementation will always reliably 
result in the *current* SHA1 being included in the .config. AFAICT 
the .config only actually gets written if there are changes, or if you 
explicitly do a 'make oldconfig'.

But if you e.g. pull a stable update and just run 'make', the .config will 
likely remain unchanged and will thus still contain the SHA1 from a 
previous build.

Cheers,
FJP
