Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbYLEXS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbYLEXS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 18:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYLEXSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 18:18:14 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:39717 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751768AbYLEXSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 18:18:13 -0500
Message-ID: <4939B6AF.2060901@lwfinger.net>
Date: Fri, 05 Dec 2008 17:18:07 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Christian Lamparter <chunkeey@web.de>, linux-wireless@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       John W Linville <linville@tuxdriver.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] p54usb: fix usb_kill_urb hang with slub_debug=P
References: <200812051547.45790.chunkeey@web.de> <20081205155356.GC28030@suse.de>
In-Reply-To: <20081205155356.GC28030@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Dec 05, 2008 at 03:47:45PM +0100, Christian Lamparter wrote:
>> This patch fixes a problem identified by Johannes Berg.
> 
> No, it only papers over the real problem here, let's work on a correct
> patch please.

I can contribute a little info. If SLUB debugging is enabled, and the boot
command includes 'slub_debug=P', I get a GPF in kref_get(), which is called from
kobject_get() with the following code:

        if (kobj)
                kref_get(&kobj->kref);

>From the dump, &kobj->kref is 0x6b6b6b6b6b6b6dbb, a poisoned value.

Somewhere, the "struct urb" has been freed, but kobj has not been set to NULL.

As everything I've found is a symptom, I'm still looking for the real cause.

Larry



