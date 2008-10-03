Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608AbYJCLXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbYJCLXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 07:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYJCLXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 07:23:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39054 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbYJCLXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 07:23:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/6] Hibernation: Introduce new system state for the last phase of hibernation
Date: Fri, 3 Oct 2008 13:27:18 +0200
User-Agent: KMail/1.9.9
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <200808290002.55026.rjw@sisk.pl> <200809300010.39000.rjw@sisk.pl> <20081003013557.42ce685d.akpm@linux-foundation.org>
In-Reply-To: <20081003013557.42ce685d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810031327.19293.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 3 of October 2008, Andrew Morton wrote:
> On Tue, 30 Sep 2008 00:10:37 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Hibernation: Introduce new system state for the last phase of hibernation
> > 
> > Replace unused SYSTEM_SUSPEND_DISK with a new system_state value
> > SYSTEM_HIBERNATE_ENTER that can be used by device drivers to check if
> > the system is in the last phase of hibernation.
> 
> Violent objections.
> 
> We just don't know what this change will do.  It potentially affects
> every code site in the kernel which looks at system_state.

Do you mean anyone checking 'system_state != SOMETHING' ?  Oh well.

> We've had problems in the past with this thing and the more complex we make it,
> the worse any future problems will be.  It's Just Bad.
> 
> Can we just create a new global?
> 
> 	extern bool system_entering_hibernation_or_whatever;

Yes, we can, but what about:

extern bool system_entering_hibernation(void);

that will become a static inline in case of !CONFIG_HIBERNATION,
and using a static variable?
