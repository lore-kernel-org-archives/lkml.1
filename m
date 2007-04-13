Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbXDMQlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbXDMQlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 12:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbXDMQlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 12:41:17 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48273 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbXDMQlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 12:41:17 -0400
Date: Fri, 13 Apr 2007 18:41:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: make clean for DocBook
Message-ID: <20070413164142.GA14706@uranus.ravnborg.org>
References: <20070413090658.b4c4bc8f.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413090658.b4c4bc8f.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 09:06:58AM -0700, Randy Dunlap wrote:
> Hi Sam,
> 
> 'make clean' doesn't seem to descend into Documentation/DocBook/.
> At least 'make V=1 clean' doesn't show me any references in DocBook.
> 
> I guess that this is because DocBook doesn't have anything that
> qualifies in obj-y/m/n and subdir-y/m/n.  (?)

Documentation/ is handled explicit i top-level Makefile:

mrproper-dirs      := $(addprefix _mrproper_,Documentation/DocBook scripts)

PHONY += $(mrproper-dirs) mrproper archmrproper
$(mrproper-dirs):
        $(Q)$(MAKE) $(clean)=$(patsubst _mrproper_%,%,$@)


And we will visit DocBook with mrproper - but not clean.
I have no stron opinion when to delete generated files in DocBook.

	Sam
