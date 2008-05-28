Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837AbYE1RIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbYE1RIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 13:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbYE1RIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 13:08:32 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39519 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbYE1RIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 13:08:31 -0400
Date: Wed, 28 May 2008 19:08:30 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: thunder7@xs4all.nl
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: vt/fbcon: fix background color on line feed
In-Reply-To: <20080527193304.GA21560@amd64.of.nowhere>
Message-ID: <alpine.LNX.1.10.0805281003040.12937@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0805101015110.19952@fbirervta.pbzchgretzou.qr> <20080527193304.GA21560@amd64.of.nowhere>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 2008-05-27 21:33, thunder7@xs4all.nl wrote:
>
>I used to force my console to black-on-white by the command 'setterm
>inversescreen on'. This worked well. In 2.6.26-rc4, I get lots of black
>background characters. Something as simple as typing 'ls' multiple times
>until the screen scrolls gives black characters. I see them at the end
>of lines, I see spaces changed in black characters, I see lots of black. 

commit 7f676fb7cf34dd2982d0cf79aeea7e5b06ad91eb
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed May 28 10:00:41 2008 +0200

    vt: fix background color on line feed, DEC invert
    
    Original report: """I used to force my console to black-on-white by
    the command `setterm -inversescreen on`. In 2.6.26-rc4, I get lots of
    black background characters."""
    
    Another addendum to commit c9e587ab.
    This was previously missed out since I was not aware of what
    vc_decscnm was for.
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 drivers/char/vt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index fa1ffbf..b8b2498 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -434,7 +434,7 @@ static void update_attr(struct vc_data *vc)
 	              vc->vc_blink, vc->vc_underline,
 	              vc->vc_reverse ^ vc->vc_decscnm, vc->vc_italic);
 	vc->vc_video_erase_char = (build_attr(vc, vc->vc_color, 1, vc->vc_blink, 0, vc->vc_decscnm, 0) << 8) | ' ';
-	vc->vc_scrl_erase_char = (build_attr(vc, vc->vc_def_color, 1, false, false, false, false) << 8) | ' ';
+	vc->vc_scrl_erase_char = (build_attr(vc, vc->vc_def_color, 1, false, false, vc->vc_decscnm, false) << 8) | ' ';
 }
 
 /* Note: inverting the screen twice should revert to the original state */
