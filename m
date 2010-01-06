Return-Path: <linux-kernel-owner+w=401wt.eu-S932677Ab0AFUA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677Ab0AFUA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932411Ab0AFUA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:00:27 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55329 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392Ab0AFUA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:00:27 -0500
Date: Wed, 6 Jan 2010 14:55:03 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: wireless, fix lock imbalance
Message-ID: <20100106195503.GB2870@tuxdriver.com>
References: <1262795743-15009-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262795743-15009-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 05:35:42PM +0100, Jiri Slaby wrote:
> One fail path in cfg80211_wext_siwscan omits to unlock rdev->mtx.
> Fix that.
> 
> Trigerrable by "Scan for SSID" with long enough SSID (> 32).
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Both this and the next one are already fixed in wireless-2.6...

commit 65486c8b30498dd274eea2c542696f22b63fe5b8
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Wed Dec 23 15:33:35 2009 +0100

    cfg80211: fix error path in cfg80211_wext_siwscan
    
    If there's an invalid channel or SSID, the code leaks
    the scan request. Always free the scan request, unless
    it was successfully given to the driver.
    
    Reported-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Acked-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
