Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbZCLJh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbZCLJh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbZCLJhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:37:11 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:42553
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbZCLJhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:37:09 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Date: Thu, 12 Mar 2009 04:37:03 -0500
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; x86_64; ; )
Cc: dwmw2@infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903120437.03837.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I'm doing this:

make ARCH=m68k headers_install INSTALL_HDR_PATH=walrus

And it doesn't install unistd_mm.h which is included from asm/unistd.h.  (The 
file is there in arch/m68k/include/asm/unistd_mm.h, it just doesn't get 
installed.  So any code that #includes <asm/unistd.h> results in a file not 
found error for the other one, which is essentially just a wrapper.)

I don't understand what the code's currently doing here well enough to fix it, 
specifically where does this file list come from?  The file  
arch/m68k/include/asm/Kbuild is adding "cachectl.h" to header-y, but there are 
31 files getting installed from that directory and only one in there.  If the 
list was just the contents of the directory, then unistd_mm.h (and 
unistd_no.h) would get installed, but they don't.  I could add those two to 
the Kbuild file after cachectl.h, but is that the _right_ fix?  Where are the 
other 31 identified?  (Is it getting a listing of some _other_ directory?)

Confused,

Rob
