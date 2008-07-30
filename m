Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbYG3Gdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbYG3Gdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 02:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYG3Gdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 02:33:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbYG3Gdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 02:33:43 -0400
Date: Tue, 29 Jul 2008 23:32:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       lkml <linux-kernel@vger.kernel.org>, Jean Delvare <khali@linux-fr.org>,
       Juerg Haefliger <juergh@gmail.com>
Subject: Re: [RESEND x9+ patch 2.6.26-git 1/2] lm75:  cleanup and reorg
Message-Id: <20080729233231.0ced6d9b.akpm@linux-foundation.org>
In-Reply-To: <200807251523.28242.david-b@pacbell.net>
References: <200807251523.28242.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 15:23:28 -0700 David Brownell <david-b@pacbell.net> wrote:

> Minor cleanup and reorg of the lm75 code.

This patch (and the other) have been in Mark's tree for a month or so. 
(linux-next <- useful!)

Mark has been pretty, umm, low-key lately.  I've attached the full
git-hwmon changelog below and the authors of all those changes are
cc'ed.

Could people please confirm that what is in linux-next is still the
latest and greatest version of their changes?  If so, I shall plan on
fishing those changes out of there and getting them into -rc2.

Thanks.


commit 530598a47e8562f680d155eb280dddd6af1b3d9e
Author: Jean Delvare <khali@linux-fr.org>
Date:   Wed Jun 25 09:10:30 2008 -0400

    hwmon: (lm85) Simplify device initialization function
    
    Clean up and simplify the device initialization function:
    * Degrade error messages to warnings - what they really are.
    * Stop warning about VxI mode, we don't really care.
    * Drop comment about lack of limit initialization - that's the standard
      way, all hardware monitoring drivers do that.
    * Only read the configuration register once.
    * Only write back to the configuration register if needed.
    * Don't attempt to clear the lock bit, it locks itself to 1.
    * Move the function to before it's called, so that we no longer need to
      forware declare it.
    
    Signed-off-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

commit 231858233b28b8d1b3bd2b5b2c8485b45a000ec2
Author: Jean Delvare <khali@linux-fr.org>
Date:   Wed Jun 25 08:47:35 2008 -0400

    hwmon: (lm85) Misc cleanups
    
    Misc cleanups to the lm85 hardware monitoring driver:
    * Mark constant arrays as const.
    * Remove useless masks.
    * Have lm85_write_value return void - nobody is checking the returned
      value anyway and in some cases it was plain wrong.
    * Remove useless initializations.
    * Rename new_client to client in lm85_detect.
    * Replace cascaded if/else with a switch/case in lm85_detect.
    * Group similar loops in lm85_update_device.
    * Remove legacy comments.
    
    Signed-off-by: Jean Delvare <khali@linux-fr.org>
    Acked-by: Juerg Haefliger <juergh at gmail.com>
    Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

commit b84465f713e0d8a041db0447534b048d74972341
Author: Jean Delvare <khali@linux-fr.org>
Date:   Sat Apr 12 19:56:35 2008 +0200

    hwmon: (lm85) Don't write back cached values
    
    In set_pwm_auto_pwm_minctl, we write cached register bits back to the
    chip. This is a bad idea as we have no guarantee that the cache is
    up-to-date. Better read a fresh register value from the chip, it's
    safer and in fact it is also more simple.
    
    Signed-off-by: Jean Delvare <khali@linux-fr.org>
    Acked-by: Juerg Haefliger <juergh at gmail.com>
    Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

commit 0d78cd2a2a3b870b409769852189f58d954da386
Author: Jean Delvare <khali@linux-fr.org>
Date:   Thu May 1 08:47:33 2008 +0200

    hwmon: (lm85) Drop dead code
    
    Drop a lot of useless register defines, conversion macros, data structure
    members and update code. All these register values were read from the
    device but nothing is done out of them, so this is all dead code in
    practice.
    
    Signed-off-by: Jean Delvare <khali@linux-fr.org>
    Acked-by: Juerg Haefliger <juergh at gmail.com>
    Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

commit 54edd6a00cd77019b3e29ca145414f69e9f9d14b
Author: Jean Delvare <khali@linux-fr.org>
Date:   Tue Apr 29 14:03:37 2008 +0200

    hwmon: (lm85) Coding-style cleanups
    
    Fix most style issues reported by checkpatch, including:
    * Trailing, missing and extra whitespace
    * Extra parentheses, curly braces and semi-colons
    * Broken indentation
    * Lines too long
    
    I verified that the generated code is the same before and after
    these changes.
    
    Signed-off-by: Jean Delvare <khali@linux-fr.org>
    Acked-by: Juerg Haefliger <juergh at gmail.com>
    Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

commit ea6db11742de63324f29d1383122657cabe90940
Author: David Brownell <david-b@pacbell.net>
Date:   Sat May 3 19:33:15 2008 -0700

    hwmon: (lm75) add new-style driver binding
    
    More LM75 updates:
    
     - Teach the LM75 driver to use new-style driver binding:
    
         * Create a second driver struct, using new-style driver binding
           methods cribbed from the legacy code.
    
         * Add a MODULE_DEVICE_TABLE (for "newER-style binding")
    
         * The legacy probe logic delegates its work to this new code.
    
         * The legacy driver now uses the name "lm75_legacy".
    
     - More careful initialization.  Chips are put into 9-bit mode so
       the current interconversion routines will never fail.
    
     - Save the original chip configuration, and restore it on exit.
       (Among other things, this normally turns off the mode where
       the chip is constantly sampling ... and thus saves power.)
    
    So the new-style code should catch all chips that boards declare,
    while the legacy code catches others.  This particular coexistence
    strategy may need some work yet ... legacy modes might best be set
    up explicitly by some tool not unlike "sensors-detect".  (Or else
    completely eradicated...)
    
    Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
    Acked-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

commit 6916fbc0e5c8d59d663331034ce44ef85bfb50b1
Author: David Brownell <david-b@pacbell.net>
Date:   Mon Apr 21 12:10:53 2008 -0700

    hwmon: (lm75) cleanup/reorg
    
    Minor cleanup and reorg of the lm75 code.
    
     - Kconfig provides a larger list of lm75-compatible chips
    
     - A top comment now says what the driver does (!) ... as in, just
       what sort of sensor is this??
    
     - Section comments now delineate the various sections of the driver:
       hwmon attributes, driver binding, register access, module glue.
       One driver binding function moved out of the attribute section,
       as did the driver struct itself.
    
     - Minor tweaks to legacy probe logic:  correct a comment, and
       remove a pointless variable.
    
     - Whitespace, linelength, and comment fixes.
    
    This patch should include no functional changes.  It's preparation
    for adding new-style (driver model) I2C driver binding.
    
    Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
    Acked-by: Jean Delvare <khali@linux-fr.org>
    Acked-by: Laurent Pinchart <laurentp@cse-semaphore.com>
    Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

commit d8db8e40b05bdaa4f5888f2a762533079ebee458
Author: Mark M. Hoffman <mhoffman@lightlink.com>
Date:   Mon May 26 15:09:36 2008 -0400

    hwmon: (adt7473) clarify an awkward bit of code
    
    Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>
    Acked-by: Jean Delvare <khali@linux-fr.org>

commit 36e847483a14121f1c51b290b9ddeb91f1e58996
Author: Jean Delvare <khali@linux-fr.org>
Date:   Sat Apr 26 16:28:27 2008 +0200

    hwmon: (adt7473) Remove unused defines
    
    All the *_MAX_ADDR defines are never used, so remove them. The number
    of registers of each type is already expressed by the *_COUNT defines.
    
    Signed-off-by: Jean Delvare <khali@linux-fr.org>
    Acked-by: Darrick J. Wong <djwong@us.ibm.com>
    Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

commit 55e019e7f2b7737348fc71995823e824165fb0b5
Author: Juerg Haefliger <juergh@gmail.com>
Date:   Tue Mar 25 21:49:15 2008 -0700

    hwmon: (dme1737) fix voltage scaling
    
    This patch fixes a voltage scaling issue for the sch311x device.
    
    Signed-Off-By: Juerg Haefliger <juergh at gmail.com>
    Acked-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

commit 535e772fc505b311bbed42dcc308ea96a0890cbf
Author: Juerg Haefliger <juergh@gmail.com>
Date:   Thu Apr 3 21:34:19 2008 -0700

    hwmon: (dme1737) probe all addresses
    
    This patch adds a module load parameter to enable probing of
    non-standard LPC addresses 0x162e and 0x164e when scanning for supported
    ISA chips.
    
    Signed-Off-By: Juerg Haefliger <juergh at gmail.com>
    Acked-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

commit 554045a0ba16fffb6bb832919b72a4f692d9add4
Author: Juerg Haefliger <juergh@gmail.com>
Date:   Tue Mar 25 21:49:02 2008 -0700

    hwmon: (dme1737) demacrofy for readability
    
    This patch gets rid of a couple of macros previously used for sysfs attribute
    generation and manipulation. This makes the source a little bigger but a lot
    more readable and maintainable. It also fixes an issue with pwm5 & pwm6
    attributes not being created read-only initially.
    
    Signed-Off-By: Juerg Haefliger <juergh at gmail.com>
    Acked-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

