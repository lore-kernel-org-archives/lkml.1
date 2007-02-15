Return-Path: <linux-kernel-owner+w=401wt.eu-S1161561AbXBOWdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161561AbXBOWdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161563AbXBOWdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:33:35 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:60839 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161561AbXBOWde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:33:34 -0500
Date: Thu, 15 Feb 2007 23:33:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: kbuild question
Message-ID: <20070215223356.GA7880@uranus.ravnborg.org>
References: <930B9C2E-DCE3-4E9E-AA6B-2C58E16736B2@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <930B9C2E-DCE3-4E9E-AA6B-2C58E16736B2@kernel.crashing.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 01:18:52PM -0600, Kumar Gala wrote:
> I was wondering if there was some way to make a Kconfig menu either  
> be just a menu or a choice depending on another bool being set or not.
> 
> What I'm trying to accomplish is if CONFIG_ONLY_HAVE_ONE is set I  
> want it so you can only select on option, however if  
> CONFIG_ONLY_HAVE_ONE is not set you should be able to select multiple  
> options.

You can do so using if.
See following example:
--------------------------------------------------------------
config ONLY_HAVE_ONE
	prompt "only have one?"
	boolean

if ONLY_HAVE_ONE
config FOO
	bool foo
	default y
endif

if !ONLY_HAVE_ONE
choice
	prompt "multiple values"
	default VAL_FIRST

config VAL_FIRST
	bool "First value"

config VAL_SECOND
	bool "Second value"
endchoice

endif
--------------------------------------------------------------

You should be able to modify this for the usage you ask for.

Hope this is useful,

	Sam
