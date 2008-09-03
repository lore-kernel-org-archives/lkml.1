Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbYICRtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbYICRtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbYICRtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:49:09 -0400
Received: from ns1.suse.de ([195.135.220.2]:53632 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbYICRtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:49:07 -0400
Date: Wed, 3 Sep 2008 10:32:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [patch 02/16] USB: cdc-acm: dont unlock acm->mutex on error path
Message-ID: <20080903173245.GC10429@suse.de>
References: <20080903172849.927077124@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-cdc-acm-don-t-unlock-acm-mutex-on-error-path.patch"
In-Reply-To: <20080903173218.GA10429@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alexey Dobriyan <adobriyan@gmail.com>

commit 74573ee7096a4ffc2f098108d21c85801b9c7434 upstream

On Wed, Jul 23, 2008 at 03:52:36PM +0300, Andrei Popa wrote:
> I installed gnokii-0.6.22-r2 and gave the command "gnokii --identify"
> and the kernel oopsed:
>
> BUG: unable to handle kernel NULL pointer dereference at 00000458
> IP: [<c0444b52>] mutex_unlock+0x0/0xb
>  [<c03830ae>] acm_tty_open+0x4c/0x214

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Tested-by: Andrei Popa <andrei.popa@i-neo.ro>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -531,8 +531,8 @@ static int acm_tty_open(struct tty_struc
 	tasklet_schedule(&acm->urb_task);
 
 done:
-err_out:
 	mutex_unlock(&acm->mutex);
+err_out:
 	mutex_unlock(&open_mutex);
 	return rv;
 

-- 
