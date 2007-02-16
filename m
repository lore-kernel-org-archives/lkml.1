Return-Path: <linux-kernel-owner+w=401wt.eu-S932994AbXBPIuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbXBPIuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 03:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932996AbXBPIuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 03:50:04 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:40111 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932994AbXBPIuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 03:50:03 -0500
Date: Fri, 16 Feb 2007 09:50:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Kumar Gala <galak@kernel.crashing.org>,
       Roman Zippel <zippel@linux-m68k.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: kbuild question
Message-ID: <20070216085001.GA11979@uranus.ravnborg.org>
References: <930B9C2E-DCE3-4E9E-AA6B-2C58E16736B2@kernel.crashing.org> <20070215223356.GA7880@uranus.ravnborg.org> <A46E6EB1-4687-43BA-8DE9-BBAE7BD0D160@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A46E6EB1-4687-43BA-8DE9-BBAE7BD0D160@kernel.crashing.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Now is there some way to not have to duplicate the 'config choices  
> between if ONLY_HAVE_ONE and if !ONLY_HAVE_ONE
> 
> To use your example I want to do:
> 
> config ONLY_HAVE_ONE
> 	prompt "only have one?"
> 	boolean
> 
> if ONLY_HAVE_ONE
> config VAL_FIRST
> 	bool "First value"
> 
> config VAL_SECOND
> 	bool "Second value"
> endif
> 
> if !ONLY_HAVE_ONE
> choice
> 	prompt "multiple values"
> 	default VAL_FIRST
> 
> config VAL_FIRST
> 	bool "First value"
> 
> config VAL_SECOND
> 	bool "Second value"
> endchoice
> 
> endif
> 
> I'd like not to have to repeat/duplicate VAL_FIRST, VAL_SECOND, etc..

A choice allow you to select multiple values if the type of all
choice entries are of type 'tristate' but this gets enabled
only when CONFIG_MODULES equal to 'y'.
So except if you really need the 'select multiple' when MODULES
are selected I see no easy way to achive what you want.

I did not try but carefull usage of 'depends on' could also help you
but it will get messy quite fast.

Maybe Roman can se a better way?

	Sam
