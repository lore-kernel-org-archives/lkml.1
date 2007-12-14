Return-Path: <linux-kernel-owner+w=401wt.eu-S932766AbXLNDS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766AbXLNDS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 22:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbXLNDSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 22:18:49 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38295 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbXLNDSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 22:18:48 -0500
From: Darren Hart <dvhltc@linux.vnet.ibm.com>
Reply-To: Darren Hart <dvhltc@us.ibm.com>
Organization: IBM Linux Technology Center
To: "lkml, " <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc2-rt1 build failure: mod_unreg_security
Date: Thu, 13 Dec 2007 19:18:44 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-rt-users@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712131918.44236.dvhltc@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

security/realcaps.c still uses mod_unreg_security and 
unregister_security to try and unregister the realtime capabilities 
from LSM.  Those functions appear to have been removed from 
security/security.c, so the build fails with:

security/realcap.c: In function ‘realtime_exit’:
security/realcap.c:129: error: implicit declaration of 
function ‘mod_unreg_security’
security/realcap.c:133: error: implicit declaration of 
function ‘unregister_security’
‘mod_unreg_security’ only exists in the one place and in the lsm.tmpl

I compared the security.c of 2.6.23.9-rt12 and it still has the two 
missing functions.  Was there a change in how features are unregistered 
from LSM that was missed for the realcaps.c file perhaps?

I commented out the unreg calls to try and build, it completed, but the 
realcap.ko had several undefined symbols.

Kernel: arch/x86/boot/bzImage is ready  (#1)
ERROR: "cap_netlink_send" [security/realcap.ko] undefined!
ERROR: "cap_task_reparent_to_init" [security/realcap.ko] undefined!
ERROR: "cap_task_post_setuid" [security/realcap.ko] undefined!
ERROR: "cap_bprm_secureexec" [security/realcap.ko] undefined!
ERROR: "cap_bprm_set_security" [security/realcap.ko] undefined!
ERROR: "cap_vm_enough_memory" [security/realcap.ko] undefined!
ERROR: "cap_syslog" [security/realcap.ko] undefined!
ERROR: "cap_capable" [security/realcap.ko] undefined!
ERROR: "cap_capset_set" [security/realcap.ko] undefined!
ERROR: "cap_capset_check" [security/realcap.ko] undefined!
ERROR: "cap_capget" [security/realcap.ko] undefined!
ERROR: "cap_ptrace" [security/realcap.ko] undefined!
ERROR: "cap_bprm_apply_creds" [security/realcap.ko] undefined!
ERROR: "mod_reg_security" [security/realcap.ko] undefined!
ERROR: "register_security" [security/realcap.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Checking the config I see this is marked as obsolete, so maybe we don't 
care all that much - but if it wasn't just removed, I suspect we still 
want it to build?

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
