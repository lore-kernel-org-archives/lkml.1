Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934563Ab0CLUWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 15:22:16 -0500
Received: from claw.goop.org ([74.207.240.146]:52030 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab0CLUWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 15:22:14 -0500
Message-ID: <4B9AA26F.4000508@goop.org>
Date: Fri, 12 Mar 2010 12:22:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2 of 5] early PV on HVM
References: <alpine.DEB.2.00.1003101501320.28412@kaball-desktop> <4B995EA6.8080105@goop.org> <alpine.DEB.2.00.1003121819500.27222@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1003121819500.27222@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2010 11:09 AM, Stefano Stabellini wrote:
> My version is not 64-bit specific, should I move it to a new file
> anyway?
>
> I was trying to keep the differences with Sheng's version low, but in
> this case I am not quite sure how to manage it.
> Suggestions are welcome.
>    

My rough rules for code layout (in no particular order):

    * keep similar functions together (even if they're not necessarily
      sharing common code)
    * dislike externs and cross-file references (ie, prefer static
      functions/data) -> keep code sharing functions/data together
    * dislike #ifdef CONFIG_x within files; prefer Makefile rules to
      either completely compile or not compile files
    * dislike dumping-ground files
    * dislike too-small files
    * dislike moving code between files, so its better to get it right
      from the start (it makes merging harder)

So in this case, enlighten.c is the general setup/init/misc file in 
xen/.  I've been trying to move things out of it to reduce its dumping 
ground-ness.  In your case, the changes are clearly init, so they 
probably belong there.  They're compiled unconditionally, so there's no 
#ifdef.  They're fairly small so they would probably be too small in a 
separate file (unless its likely to get bigger?).  So keep in enlighten.c.

(In Sheng's version of this patch, it has more code and is conditionally 
compiled, so I think the balance tips the other way.)

     J

