Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbYBSS5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbYBSS5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbYBSS51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:57:27 -0500
Received: from qmta01.westchester.pa.mail.comcast.net ([76.96.62.16]:35822
	"EHLO QMTA01.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124AbYBSS50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:57:26 -0500
X-Authority-Analysis: v=1.0 c=1 a=rITDv7nW5hcA:10 a=1va1F5CG1Do3Buh_Sb0A:9
 a=YFCePVKBRvYU6RNdsVAA:7 a=dysd0lu6AEwbcg-OFlMGpi_87s4A:4 a=i92e0Ub4el8A:10
 a=d_-3mwAUsuEA:10 a=gi0PWCVxevcA:10
To: linux-kernel@vger.kernel.org
From: Karl Dahlke <eklhad@comcast.net>
Reply-to: Karl Dahlke <eklhad@comcast.net>
Subject: [PATCH] export getledstate()
Date: Tue, 19 Feb 2008 13:57:23 -0500
Message-ID: <20080119135723.eklhad@comcast.net>
Mime-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I write adapters for disabled people, and we often have to do
specialized functions based on keystrokes and key chords.
I would like to do certain things when keys are hit and num lock is on,
but there is no easy way to get the led state.
There is a nice function getledstate()
in keyboard.c, it just isn't exported.
Here is the patch that would do that.
Can you apply this patch, or, is there another easy way to get this information,
or, would it be better to fold this information into keyboard_notifier_param,
along with shift state etc.
I use notifiers, so this would be natural, and almost as easy.
I'd be happy to write that patch, if you think that would be a superior design.

--- drivers/char/keyboard.c	2008-02-18 21:05:23.000000000 -0500
+++ drivers/char/keyboard.c.new	2008-02-18 21:06:34.000000000 -0500
@@ -963,6 +963,7 @@ unsigned char getledstate(void)
 {
 	return ledstate;
 }
+EXPORT_SYMBOL_GPL(getledstate);
 
 void setledstate(struct kbd_struct *kbd, unsigned int led)
 {

Thanks.

Karl Dahlke
