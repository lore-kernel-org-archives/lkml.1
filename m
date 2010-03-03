Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab0CCSw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:52:29 -0500
Received: from nereida.gnuservers.com.ar ([207.192.69.134]:51680 "EHLO
	nereida.gnuservers.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab0CCSw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:52:28 -0500
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Mar 2010 13:52:27 EST
Date: Wed, 3 Mar 2010 15:42:47 -0300
From: Maximiliano Curia <maxy@debian.org>
To: David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
       Zhao Yakui <yakui.zhao@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@redhat.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [BUG #15248] Please apply the suggested fix
Message-ID: <20100303184247.GD16262@maxy.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My notebook has an I855GME video card, this video card is one of the affected
by the bug #15248 which produces a hard freeze shorly after the load of the i915
kernel module.

A git bisect showed that the affecting patch producing the hard freeze was:

commit b42d4c5c6a872815d711e5d51a600f5122c38eee
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Sep 10 15:28:04 2009 -0700

    drm/i915: use ACPI LID status for LVDS ->detect hook
    
    We can't load or hotplug detect LVDS like we can other outputs, but if
    there's a lid device present we can use it as a proxy.  This allows the
    LFP state to be determined at ->detect time, making configurations
    requiring manual intervention today "just work" assuming the lid device
    status is correct.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

Afterwards, I realized this had already been reverted in a patch present only
in git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git :

commit 7b9c5abee98c54f85bcc04bd4d7ec8d5094c73f4
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Fri Feb 12 09:30:00 2010 -0800

    drm/i915: give up on 8xx lid status
    
    These old machines more often than not lie about their lid state.  So
    don't use it to detect LVDS presence, but leave the event handler to
    deal with lid open/close, when we might need to reset the mode.
    
    Fixes kernel bug #15248
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Cc: stable@kernel.org
    Signed-off-by: Eric Anholt <eric@anholt.net>

This patch is suggested as fix for #15248, but it may have got lost in the
noise.

After applying this patch (and only this patch), my computer worked perfectly
again, with kms enabled.

Please do apply this patch in the mainline kernel.

Thanks,
-- 
"The use of COBOL cripples the mind; its teaching should, therefore, be
regarded as a criminal offense." -- Edsger W. Dijkstra
Saludos /\/\ /\ >< `/
