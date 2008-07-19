Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbYGSMk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbYGSMk2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 08:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbYGSMkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 08:40:21 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:52090 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbYGSMkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 08:40:20 -0400
Message-ID: <4881E130.5000408@keyaccess.nl>
Date: Sat, 19 Jul 2008 14:42:24 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>
CC: dri-users@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Long delay depending on xorg.conf "AGPSize" option
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day.

Not sure I'm on the right list(s) -- if not, a suggestion for another 
one would be welcome.

I normally don't run 3D apps and haven't set the X.org "AGPSize" option 
which (I believe) means or meant it uses a default 8MB. Today I was 
playing around a bit with 3D and saw rather long delays upon starting 
and exiting X depending on the size set.

X is "X.org X Server 1.4.2", kernel is 2.6.26. Hardware is an AGP Matrox 
Millenium G550 32MB (X driver "mga", kernel CONFIG_DRM_MGA) and the AGP 
GART is AMD 751, CONFIG_AGP_AMD. CPU is a Duron 1300. During testing, 
the AGP aperture was set to 256M in the BIOS, normally it's 64M.

AGP mode is 2x (Option "AGPMode" "2"). Without an AGPSize option or with 
Option "AGPSize "8", the delay between my monitor switching to graphics 
mode and my desktop appearing is about 2 seconds:

No/8	: 2 seconds
16	: 3 seconds
32	: 4 seconds
64	: 6 seconds
128	: 12 seconds

Similar (somewhat shorter, but related in the same way) delays are 
present upon exiting X again as well, from the point where my monitor 
switches to text mode to me getting back a prompt.

I have played around with 3D before and am sure that back then the 64M 
setting did not produce any delays over not having the option set. That 
6 seconds now is rather long, and especially the one while exiting X 
feels odd.

Are these delays expected? And/or not a DRM/AGP but X issue? Mesa seems 
to be 7.0.2 if it matters:

# glxinfo | head -29
name of display: :0.0
display: :0  screen: 0
direct rendering: Yes
server glx vendor string: SGI
server glx version string: 1.2
server glx extensions:
     GLX_ARB_multisample, GLX_EXT_visual_info, GLX_EXT_visual_rating,
     GLX_EXT_import_context, GLX_EXT_texture_from_pixmap, 
GLX_OML_swap_method,
     GLX_SGI_make_current_read, GLX_SGIS_multisample, GLX_SGIX_hyperpipe,
     GLX_SGIX_swap_barrier, GLX_SGIX_fbconfig, GLX_MESA_copy_sub_buffer
client glx vendor string: SGI
client glx version string: 1.4
client glx extensions:
     GLX_ARB_get_proc_address, GLX_ARB_multisample, GLX_EXT_import_context,
     GLX_EXT_visual_info, GLX_EXT_visual_rating, GLX_MESA_allocate_memory,
     GLX_MESA_copy_sub_buffer, GLX_MESA_swap_control,
     GLX_MESA_swap_frame_usage, GLX_OML_swap_method, GLX_OML_sync_control,
     GLX_SGI_make_current_read, GLX_SGI_swap_control, GLX_SGI_video_sync,
     GLX_SGIS_multisample, GLX_SGIX_fbconfig, GLX_SGIX_pbuffer,
     GLX_SGIX_visual_select_group, GLX_EXT_texture_from_pixmap
GLX version: 1.2
GLX extensions:
     GLX_ARB_get_proc_address, GLX_ARB_multisample, GLX_EXT_import_context,
     GLX_EXT_visual_info, GLX_EXT_visual_rating, GLX_MESA_swap_control,
     GLX_MESA_swap_frame_usage, GLX_OML_swap_method, 
GLX_SGI_make_current_read,
     GLX_SGI_video_sync, GLX_SGIS_multisample, GLX_SGIX_fbconfig
OpenGL vendor string: VA Linux Systems Inc.
OpenGL renderer string: Mesa DRI G400 20061030 AGP 2x x86/MMX+/3DNow!+/SSE
OpenGL version string: 1.2 Mesa 7.0.2

Thanks in advance for insights/advice...

Rene.
