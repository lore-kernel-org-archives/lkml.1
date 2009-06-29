Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbZF2KdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbZF2KdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbZF2Kcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:32:50 -0400
Received: from smtp.nokia.com ([192.100.122.233]:55269 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759259AbZF2Kct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:32:49 -0400
Subject: Re: [PATCH 0/2] fix gpio-keys debouncing and timer sleep issues
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: ext Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "alek.du@intel.com" <alek.du@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "soni.trilok@gmail.com" <soni.trilok@gmail.com>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>,
       "Carmody Phil.2 (EXT-Ixonos/Helsinki)" <ext-phil.2.carmody@nokia.com>
In-Reply-To: <20090629055940.GC12821@dtor-d630.eng.vmware.com>
References: <20090626002345.07928230@dxy.sh.intel.com>
	 <cover.1246015395.git.ext-jani.1.nikula@nokia.com>
	 <20090629055940.GC12821@dtor-d630.eng.vmware.com>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 13:32:28 +0300
Message-Id: <1246271548.20530.207.camel@jani-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jun 2009 10:32:34.0118 (UTC) FILETIME=[EA034E60:01C9F8A4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-29 at 07:59 +0200, ext Dmitry Torokhov wrote:
> I intend to apply the both patches. It is unfortunate that we need to
> use both a timer and a workqueue, I wonder what would it take to
> implement something like reschedule_delayed_work() that would adjust
> the delay in the same fashion that mod_timer() does?

Hi Dmitry -

Since a delayed_work is simply a work_struct and a timer_list, the only
overhead here is the one line timer function. A work_struct per button
is of course an addition to the original in both Alek's patch and mine,
but I guess there are no alternatives if gpio_get_value may sleep.

I did think about something like reschedule_delayed_work myself, but
tackling the locking issues seemed like too much work compared to this
simple solution.


BR,
Jani.


