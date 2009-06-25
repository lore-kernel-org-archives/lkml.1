Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbZFYQ2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbZFYQ2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 12:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZFYQ2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 12:28:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:7975 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbZFYQ2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 12:28:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,291,1243839600"; 
   d="scan'208";a="425328249"
Date: Fri, 26 Jun 2009 00:23:45 +0800
From: Alek Du <alek.du@intel.com>
To: "ext-phil.2.carmody@nokia.com" <ext-phil.2.carmody@nokia.com>
CC: "Nikula Jani.1 (EXT-Nixu/Helsinki)" <ext-jani.1.nikula@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Trilok Soni <soni.trilok@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>
Subject: Re: [PATCH]input: Change timer function to workqueue for gpio_keys
 driver
Message-ID: <20090626002345.07928230@dxy.sh.intel.com>
In-Reply-To: <1245946154.9103.742.camel@pcarmody-desktop>
References: <20090608152420.0e76c302@dxy.sh.intel.com>
	<5d5443650906121040n3f36c99eka01f5eb5274ee6ff@mail.gmail.com>
	<359ed6810906250329x70cf380cy278f23e3ebc6a829@mail.gmail.com>
	<20090625210642.432e08a5@dxy.sh.intel.com>
	<1245936693.20530.107.camel@jani-desktop>
	<20090625220826.1fa7413e@dxy.sh.intel.com>
	<1245941565.20530.134.camel@jani-desktop>
	<1245942355.20530.141.camel@jani-desktop>
	<20090625230949.53beda65@dxy.sh.intel.com>
	<1245944528.20530.145.camel@jani-desktop>
	<20090625234846.1b987069@dxy.sh.intel.com>
	<1245946154.9103.742.camel@pcarmody-desktop>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 00:09:14 +0800
Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:

> If you stopped calling the delay after the first transition "debouncing
> time" and simply called it a "delay" you might more easily see that it
> does *no* debouncing at all. Imagine putting noise on the line
> constantly - the original code's timer would never expire. Your timer
> will expire after a delay, and while the line is still toggling
> frantically - you've not debounced.

I don't know if it is really meaningful if you want to handle such pool signal... 
Ok, if you want to handle this ultimate case, will this patch work?

        BUG_ON(irq != gpio_to_irq(button->gpio));

+       cancel_delayed_work_sync(&bdata->work);
        delay = button->debounce_interval ?
                        msecs_to_jiffies(button->debounce_interval) : 0;
        schedule_delayed_work(&bdata->work, delay);

Alek
> Please investigate the meaning and implications of "debouncing" before
> claiming your code does it.
> 
> Phil
> 
