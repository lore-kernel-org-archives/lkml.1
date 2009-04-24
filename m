Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbZDXKgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbZDXKgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 06:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZDXKgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 06:36:31 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:35774 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbZDXKga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 06:36:30 -0400
Date: Fri, 24 Apr 2009 12:38:37 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Suggestions request for speed-up kernel compilation
Message-ID: <20090424103837.GA19132@uranus.ravnborg.org>
References: <63a49ef40904240257w45cc9c03n6e71ff4e4f69209b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63a49ef40904240257w45cc9c03n6e71ff4e4f69209b@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 11:57:35AM +0200, Alessio Igor Bogani wrote:
> Hi All,
> 
> Sorry for my bad English.
> 
> I'm a kernel newbie and I would be very happy to receive some tips
> about kernel compilation from experienced developers.
> 
> I have recently elaborated some trivial patches. For each one I have
> done a build test at minimum and I find myself spend a lot of time
> waiting my Core Duo to accomplish this task. Make is a very smart tool
> but after a git pull or a git fetch origin/git reset --hard origin it
> can't help as desired.
> 
> Unfortunately I don't have a clustered compilation farm under my control. :-)
> 
> Anyone can suggest me how mitigate that issue?
The kernel build system does a good job detecting what to build.
So if you touches a .h file or you change a CONFIG_ symbol used by
a header file you will see a lot of rebuilds - sometimes
more than you expected.

Try to do:

    make V=2

to see why a certain file is rebuild.


If you know you only have to build a single file you can use:

    make kernel/foo.o

If you want to build a directory - including sub-directories:

   make kernel/

If you want to build a specific module use:

    make drivers/net/foobar.ko

make help can give you a few more hints.

And try to avoid "make clean" / "make mrproper" - as this deletes all .o files.

	Sam
