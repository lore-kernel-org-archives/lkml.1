Return-Path: <linux-kernel-owner+w=401wt.eu-S1759808AbZACKzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759808AbZACKzK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 05:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZACKy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 05:54:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:55039 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZACKy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 05:54:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [1/3] KBUILD: Add script to manipulate .config files on the command line
Date: Sat, 3 Jan 2009 11:54:44 +0100
User-Agent: KMail/1.9.9
Cc: linux-kbuild@vger.kernel.org, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
References: <20090103321.351399938@firstfloor.org>
In-Reply-To: <20090103321.351399938@firstfloor.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901031154.44868.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Vyd9GCOdnwvoLOjXWL1qjftb7F5TMiD96HEy
 RszDYJJiLE2vygQONZQmIUiXwO89nfDRhi2/aMDyTkSuxtxgpr
 xQeTk3ynYIfSzJ0RuJwBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009, Andi Kleen wrote:
> 
> I often change single options in .config files. Instead of using
> an editor or one of the frontends it's convenient to do this from
> the command line. It's also useful to do from automated build scripts
> when building different variants from a base config file.
> 
> I extracted most of the CONFIG manipulation code from one of my
> build scripts into a new shell script scripts/config

This looks very useful, thanks for sharing.

> The script is not integrated with the normal Kconfig machinery
> and doesn't do any checking against Kconfig files, but just manipulates
> that text format. This is always done at make time anyways.

Why? I would imagine it to be useful to get immediate feedback
whether changing the option was successful. It should be easy to
run scripts/kconfig/conf -o on the config file afterwards.

My normal workflow when changing single options is to remove the
line from .config and call make oldconfig again. What I would
like to see most here is something like

./scripts/config --reconfigure smp
Remove SMP from .config, and do oldconfig to ask again.

	Arnd <><
