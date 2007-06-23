Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbXFWIqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbXFWIqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 04:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXFWIqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 04:46:39 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:47350 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbXFWIqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 04:46:37 -0400
Message-ID: <467CDDEB.2090602@free.fr>
Date: Sat, 23 Jun 2007 10:46:35 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070509 Iceape/1.1.2 (Debian-1.1.2-1)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-net@vger.kernel.org
Subject: Re: FW : airo suspend problem
References: <1181985273.4673a9f9e9a4e@imp.free.fr> <20070622205817.GA3885@ucw.cz>
In-Reply-To: <20070622205817.GA3885@ucw.cz>
Content-Type: multipart/mixed;
 boundary="------------070805090001080004080101"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070805090001080004080101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Pavel Machek wrote:
> Hi!
> 
>>   Sujet : airo suspend problem
>>       ? : linux-pm@lists.osdl.org
>>
>> Hi,
>>
>> the airo driver (drivers/net/wireless/airo.c) does in its suspend routine [1].
>> But not all the pci cards support power management and cause
>> pci_enable_wake/pci_set_power_state to return errors.
>>
>> On pci card that don't support PM, what should be done ?
>> Don't call pci_enable_wake/pci_set_power_state ?
> 
> That sounds right. Or simply ignore errors from enable_wake and
> set_power_state?

Ok, I'll try to cook a patch.
> 
>> PS : after the failed suspend to ram due to airo driver, I tried to unload airo
>> driver and it hanged. After a reset, I got my ext3 root fs corrupted :(
> 
> Corrupted or 'just needed journal replay'?
Really corrupted :
on reboot, there was no journal replay, but boot hanged. After some 
investigation some symbolic links were pointing to garbage (lot's of 
/etc/rcx.d/ ones). After a fsck (partial log attached) and some manual 
fix for symbolic links, the system was operational.


Matthieu

--------------070805090001080004080101
Content-Type: text/plain;
 name="pb"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pb"

/dev/hdb3 contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Symlink /etc/rc0.d/K99local (inode #375211) is invalid.
Clear? no

Entry 'K99local' in /etc/rc0.d (375176) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc0.d/S32portmap (inode #375205) is invalid.
Clear? no

Entry 'S32portmap' in /etc/rc0.d (375176) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc1.d/K11cron (inode #375203) is invalid.
Clear? no

Entry 'K11cron' in /etc/rc1.d (375201) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc1.d/K99local (inode #375459) is invalid.
Clear? no

Entry 'K99local' in /etc/rc1.d (375201) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc1.d/K20hddtemp (inode #375206) is invalid.
Clear? no

Entry 'K20hddtemp' in /etc/rc1.d (375201) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc1.d/K20makedev (inode #375208) is invalid.
Clear? no

Entry 'K20makedev' in /etc/rc1.d (375201) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc1.d/K20smartmontools (inode #375209) is invalid.
Clear? no

Entry 'K20smartmontools' in /etc/rc1.d (375201) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc1.d/K20ssh (inode #375210) is invalid.
Clear? no

Entry 'K20ssh' in /etc/rc1.d (375201) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc1.d/K89atd (inode #375212) is invalid.
Clear? no

Entry 'K89atd' in /etc/rc1.d (375201) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc1.d/K89klogd (inode #375213) is invalid.
Clear? no

Entry 'K89klogd' in /etc/rc1.d (375201) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc1.d/K90sysklogd (inode #375214) is invalid.
Clear? no

Entry 'K90sysklogd' in /etc/rc1.d (375201) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc2.d/S10sysklogd (inode #375218) is invalid.
Clear? no

Entry 'S10sysklogd' in /etc/rc2.d (375217) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc2.d/S11klogd (inode #375221) is invalid.
Clear? no

Entry 'S11klogd' in /etc/rc2.d (375217) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc2.d/S20hddtemp (inode #375224) is invalid.
Clear? no

Entry 'S20hddtemp' in /etc/rc2.d (375217) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc2.d/S20makedev (inode #375226) is invalid.
Clear? no

Entry 'S20makedev' in /etc/rc2.d (375217) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc2.d/S20smartmontools (inode #375227) is invalid.
Clear? no

Entry 'S20smartmontools' in /etc/rc2.d (375217) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc2.d/S20ssh (inode #375228) is invalid.
Clear? no

Entry 'S20ssh' in /etc/rc2.d (375217) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc2.d/S89atd (inode #375229) is invalid.
Clear? no

Entry 'S89atd' in /etc/rc2.d (375217) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc2.d/S89cron (inode #375230) is invalid.
Clear? no

Entry 'S89cron' in /etc/rc2.d (375217) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc2.d/S99rmnologin (inode #375232) is invalid.
Clear? no

Entry 'S99rmnologin' in /etc/rc2.d (375217) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rc5.d/S30gdm (inode #375231) is invalid.
Clear? no

Entry 'S30gdm' in /etc/rc5.d (375268) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rcS.d/S01glibc.sh (inode #375480) is invalid.
Clear? no

Entry 'S01glibc.sh' in /etc/rcS.d (375310) has an incorrect filetype (was 7, should be 0).
Fix? no

Symlink /etc/rcS.d/S04mountdevsubfs.sh (inode #375216) is invalid.
Clear? no

Entry 'S04mountdevsubfs.sh' in /etc/rcS.d (375310) has an incorrect filetype (was 7, should be 0).
Fix? no

Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Inode 131393 ref count is 17665, should be 1.  Fix? no

Unattached zero-length inode 131394.  Clear? no

Unattached inode 131394
Connect to /lost+found? no

Inode 131395 ref count is 17665, should be 1.  Fix? no

Unattached zero-length inode 131396.  Clear? no

Unattached inode 131396
Connect to /lost+found? no

Inode 131397 ref count is 17665, should be 1.  Fix? no

Inode 131398 ref count is 17665, should be 1.  Fix? no

Inode 131399 ref count is 17665, should be 1.  Fix? no

Inode 131400 ref count is 17665, should be 1.  Fix? no

Inode 131401 ref count is 17921, should be 1.  Fix? no

Inode 131402 ref count is 17921, should be 1.  Fix? no

Inode 131403 ref count is 17665, should be 1.  Fix? no

Inode 131404 ref count is 17665, should be 1.  Fix? no

Inode 131405 ref count is 17665, should be 1.  Fix? no

Inode 131406 ref count is 17665, should be 1.  Fix? no

Inode 131407 ref count is 17665, should be 1.  Fix? no

Inode 131408 ref count is 17665, should be 1.  Fix? no

Inode 131409 ref count is 17665, should be 1.  Fix? no

Inode 131410 ref count is 17665, should be 1.  Fix? no

Inode 131411 ref count is 17665, should be 1.  Fix? no

Inode 131412 ref count is 17665, should be 1.  Fix? no

Inode 131413 ref count is 17665, should be 1.  Fix? no

Inode 131414 ref count is 17665, should be 1.  Fix? no

Inode 131415 ref count is 17921, should be 1.  Fix? no

Inode 131416 ref count is 17921, should be 1.  Fix? no

Inode 131417 ref count is 17921, should be 1.  Fix? no

Inode 131418 ref count is 17921, should be 1.  Fix? no

Inode 131419 ref count is 17921, should be 1.  Fix? no

Inode 131420 ref count is 17921, should be 1.  Fix? no

Inode 131421 ref count is 17921, should be 1.  Fix? no

Inode 131422 ref count is 17665, should be 1.  Fix? no

Inode 131423 ref count is 17921, should be 1.  Fix? no

Inode 131424 ref count is 17921, should be 1.  Fix? no

Inode 137537 ref count is 17922, should be 2.  Fix? no

Unattached zero-length inode 137538.  Clear? no

Unattached inode 137538
Connect to /lost+found? no

Inode 137539 ref count is 17921, should be 1.  Fix? no

Inode 137540 ref count is 17921, should be 1.  Fix? no

Inode 137541 ref count is 17921, should be 1.  Fix? no

Inode 137542 ref count is 17921, should be 1.  Fix? no

Inode 137543 ref count is 17923, should be 3.  Fix? no

Inode 137544 ref count is 17665, should be 1.  Fix? no

Inode 137545 ref count is 17921, should be 1.  Fix? no

Inode 137546 ref count is 17926, should be 6.  Fix? no

Inode 137547 ref count is 17921, should be 1.  Fix? no

Inode 137548 ref count is 17921, should be 1.  Fix? no

Inode 137549 ref count is 17922, should be 2.  Fix? no

Inode 137550 ref count is 17922, should be 2.  Fix? no

Inode 137551 ref count is 17922, should be 2.  Fix? no

Inode 137552 ref count is 17921, should be 1.  Fix? no

Inode 137553 ref count is 17926, should be 6.  Fix? no

Inode 137554 ref count is 17922, should be 2.  Fix? no

Inode 137555 ref count is 17665, should be 1.  Fix? no

Inode 137556 ref count is 17922, should be 2.  Fix? no

Inode 137557 ref count is 17922, should be 2.  Fix? no

Inode 137558 ref count is 17922, should be 2.  Fix? no

Inode 137559 ref count is 17921, should be 1.  Fix? no

Inode 137560 ref count is 17921, should be 1.  Fix? no

Inode 137561 ref count is 17921, should be 1.  Fix? no

Inode 137562 ref count is 17921, should be 1.  Fix? no

Inode 137563 ref count is 17921, should be 1.  Fix? no

Inode 137564 ref count is 17665, should be 1.  Fix? no

Inode 137565 ref count is 17923, should be 3.  Fix? no

Inode 137566 ref count is 17665, should be 1.  Fix? no

Inode 137567 ref count is 17665, should be 1.  Fix? no

Inode 137568 ref count is 17665, should be 1.  Fix? no

Inode 162913 ref count is 17921, should be 1.  Fix? no

Inode 162914 ref count is 17665, should be 1.  Fix? no

Inode 162915 ref count is 17665, should be 1.  Fix? no

Inode 162916 ref count is 17921, should be 1.  Fix? no

Inode 162917 ref count is 17921, should be 1.  Fix? no

Inode 162918 ref count is 17921, should be 1.  Fix? no

Inode 162919 ref count is 17925, should be 5.  Fix? no

Inode 162920 ref count is 17921, should be 1.  Fix? no

Inode 162921 ref count is 17921, should be 1.  Fix? no

Inode 162922 ref count is 17924, should be 4.  Fix? no

Inode 162923 ref count is 17665, should be 1.  Fix? no

Inode 162924 ref count is 17921, should be 1.  Fix? no

Inode 162925 ref count is 17921, should be 1.  Fix? no

Inode 162926 ref count is 17921, should be 1.  Fix? no

Inode 162927 ref count is 17921, should be 1.  Fix? no

Inode 162928 ref count is 17935, should be 15.  Fix? no

Inode 162929 ref count is 17931, should be 11.  Fix? no

Inode 162930 ref count is 17932, should be 12.  Fix? no

Inode 162931 ref count is 17922, should be 2.  Fix? no

Inode 162932 ref count is 17922, should be 2.  Fix? no

Inode 162933 ref count is 17922, should be 2.  Fix? no

Inode 162934 ref count is 17922, should be 2.  Fix? no

Inode 162935 ref count is 17922, should be 2.  Fix? no

Inode 162936 ref count is 17922, should be 2.  Fix? no

Inode 162937 ref count is 17922, should be 2.  Fix? no

Inode 162938 ref count is 17922, should be 2.  Fix? no

Inode 162939 ref count is 17922, should be 2.  Fix? no

Inode 162940 ref count is 17922, should be 2.  Fix? no

Inode 162941 ref count is 17666, should be 2.  Fix? no

Inode 162942 ref count is 17925, should be 5.  Fix? no

Inode 162943 ref count is 17921, should be 1.  Fix? no

Inode 162944 ref count is 17921, should be 1.  Fix? no

Inode 375201 ref count is 17922, should be 2.  Fix? no

Inode 375202 ref count is 17921, should be 1.  Fix? no

Inode 375203 ref count is 17921, should be 1.  Fix? no

Inode 375204 ref count is 17665, should be 1.  Fix? no

Inode 375205 ref count is 17921, should be 1.  Fix? no

Inode 375206 ref count is 17921, should be 1.  Fix? no

Inode 375207 ref count is 17921, should be 1.  Fix? no

Inode 375208 ref count is 17921, should be 1.  Fix? no

Inode 375209 ref count is 17921, should be 1.  Fix? no

Inode 375210 ref count is 17921, should be 1.  Fix? no

Inode 375211 ref count is 17921, should be 1.  Fix? no

Inode 375212 ref count is 17921, should be 1.  Fix? no

Inode 375213 ref count is 17921, should be 1.  Fix? no

Inode 375214 ref count is 17921, should be 1.  Fix? no

Inode 375215 ref count is 17665, should be 1.  Fix? no

Inode 375216 ref count is 17921, should be 1.  Fix? no

Inode 375217 ref count is 17922, should be 2.  Fix? no

Inode 375218 ref count is 17921, should be 1.  Fix? no

Inode 375219 ref count is 16385, should be 1.  Fix? no

Inode 375220 ref count is 17921, should be 1.  Fix? no

Inode 375221 ref count is 17921, should be 1.  Fix? no

Inode 375222 ref count is 17921, should be 1.  Fix? no

Symlink ... (inode #375223) is invalid.
Clear? no

Unattached inode 375223
Connect to /lost+found? no

Inode 375224 ref count is 17921, should be 1.  Fix? no

Inode 375225 ref count is 17921, should be 1.  Fix? no

Inode 375226 ref count is 17921, should be 1.  Fix? no

Inode 375227 ref count is 17921, should be 1.  Fix? no

Inode 375228 ref count is 17921, should be 1.  Fix? no

Inode 375229 ref count is 17921, should be 1.  Fix? no

Inode 375230 ref count is 17921, should be 1.  Fix? no

Inode 375231 ref count is 17921, should be 1.  Fix? no

Inode 375232 ref count is 17921, should be 1.  Fix? no

Symlink ... (inode #375457) is invalid.
Clear? no

Unattached inode 375457
Connect to /lost+found? no

Inode 375458 ref count is 16641, should be 1.  Fix? no

Inode 375459 ref count is 17921, should be 1.  Fix? no

Inode 375460 ref count is 17921, should be 1.  Fix? no

Inode 375461 ref count is 17665, should be 1.  Fix? no

Inode 375462 ref count is 17665, should be 1.  Fix? no

Inode 375463 ref count is 17665, should be 1.  Fix? no

Inode 375464 ref count is 17665, should be 1.  Fix? no

Inode 375465 ref count is 17665, should be 1.  Fix? no

Inode 375466 ref count is 17665, should be 1.  Fix? no

Inode 375467 ref count is 17665, should be 1.  Fix? no

Inode 375468 ref count is 17665, should be 1.  Fix? no

Inode 375469 ref count is 17665, should be 1.  Fix? no

Inode 375470 ref count is 17665, should be 1.  Fix? no

Symlink ... (inode #375471) is invalid.
Clear? no

Unattached inode 375471
Connect to /lost+found? no

Inode 375472 ref count is 17921, should be 1.  Fix? no

Inode 375473 ref count is 17409, should be 1.  Fix? no

Inode 375474 ref count is 17923, should be 3.  Fix? no

Inode 375475 ref count is 17921, should be 1.  Fix? no

Symlink ... (inode #375476) is invalid.
Clear? no

Unattached inode 375476
Connect to /lost+found? no

Inode 375477 ref count is 17665, should be 1.  Fix? no

Symlink ... (inode #375478) is invalid.
Clear? no

Unattached inode 375478
Connect to /lost+found? no

Inode 375479 ref count is 17665, should be 1.  Fix? no

Inode 375480 ref count is 17921, should be 1.  Fix? no

Symlink ... (inode #375481) is invalid.
Clear? no

Unattached inode 375481
Connect to /lost+found? no

Inode 375483 ref count is 17921, should be 1.  Fix? no

Inode 375484 ref count is 17665, should be 1.  Fix? no

Inode 375485 ref count is 17665, should be 1.  Fix? no

Symlink ... (inode #375486) is invalid.
Clear? no

Unattached inode 375486
Connect to /lost+found? no

Inode 375487 ref count is 17665, should be 1.  Fix? no

Inode 375488 ref count is 17665, should be 1.  Fix? no

Inode 375727 ref count is 17665, should be 1.  Fix? no

Inode 375728 ref count is 17921, should be 1.  Fix? no

Inode 375729 ref count is 17665, should be 1.  Fix? no

Inode 375730 ref count is 17665, should be 1.  Fix? no

Inode 375731 ref count is 17665, should be 1.  Fix? no

Inode 375732 ref count is 17921, should be 1.  Fix? no

Inode 375733 ref count is 17921, should be 1.  Fix? no

Inode 375734 ref count is 17921, should be 1.  Fix? no

Inode 375735 ref count is 17665, should be 1.  Fix? no

Symlink ... (inode #375736) is invalid.
Clear? no

Unattached inode 375736
Connect to /lost+found? no

Inode 375737 ref count is 17665, should be 1.  Fix? no

Inode 375738 ref count is 17921, should be 1.  Fix? no

Inode 375739 ref count is 17665, should be 1.  Fix? no

Inode 375740 ref count is 17921, should be 1.  Fix? no

Inode 375741 ref count is 17665, should be 1.  Fix? no

Inode 375742 ref count is 17922, should be 2.  Fix? no

Symlink ... (inode #375743) is invalid.
Clear? no

Unattached inode 375743
Connect to /lost+found? no

Symlink ... (inode #375744) is invalid.
Clear? no

Unattached inode 375744
Connect to /lost+found? no

Pass 5: Checking group summary information
Inode bitmap differences:  +131394 +131396 +137538
Fix? no


/dev/hdb3: ********** WARNING: Filesystem still has errors **********

/dev/hdb3: 272499/732960 files (13.2% non-contiguous), 1331609/1464876 blocks

--------------070805090001080004080101--
