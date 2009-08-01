Return-Path: <linux-kernel-owner+w=401wt.eu-S1751307AbZHALvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbZHALvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 07:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbZHALvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 07:51:36 -0400
Received: from smtp.witbe.net ([81.88.96.48]:54025 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbZHALvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 07:51:35 -0400
X-Greylist: delayed 521 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Aug 2009 07:51:35 EDT
Date: Sat, 1 Aug 2009 13:42:39 +0200
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: rol@witbe.net
Subject: kmemleak and drm/i915 - linux 2.6.31-rc4
Message-ID: <20090801134239.7a2068cf@tux.DEF.witbe.net>
Organization: Witbe.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.2; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Trying to identify another problem, I found this one : any GL application
that is started on my machine ends adding a new entry like this one in the
kmemleak detector :

unreferenced object 0xffff880079bf9760 (size 544):
  comm "glslideshow", pid 17138, jiffies 4304401728
  backtrace:
    [<ffffffff810a7f4c>] create_object+0x186/0x287
    [<ffffffff810a8130>] kmemleak_alloc+0x21/0x45
    [<ffffffff810a3c45>] kmem_cache_alloc+0xad/0xbf
    [<ffffffff8118b441>] idr_pre_get+0x2d/0x6f
    [<ffffffff81212483>] drm_gem_handle_create+0x26/0x7a
    [<ffffffff8122bd33>] i915_gem_create_ioctl+0x55/0xa6
    [<ffffffff81210f51>] drm_ioctl+0x223/0x2c9
    [<ffffffff810b6316>] vfs_ioctl+0x6a/0x82
    [<ffffffff810b6818>] do_vfs_ioctl+0x473/0x4b9
    [<ffffffff810b68af>] sys_ioctl+0x51/0x74
    [<ffffffff8100b9eb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

This can be easily reproduced by starting glxgears for example.

Regards,
Paul
