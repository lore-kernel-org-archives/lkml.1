Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbYFJMVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbYFJMVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 08:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbYFJMUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 08:20:51 -0400
Received: from web53708.mail.re2.yahoo.com ([206.190.37.29]:27528 "HELO
	web53708.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754157AbYFJMUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 08:20:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=L+t9EzkV2YhK4Ug/EgU+6ZGPOtfx5ZGwktQUfbD/D+KNKa1KJnFzGu7xCxDd2485ciWlc/i/KxoITJj4oGA/78CR1ekMZ022HfkfUz3NcxmZaq7PuWhUgMTRv5tZaw5HEEIplp41a/7VWzd52af5Kg/FeaTIzG+LrU5jp+WQvvw=;
X-YMail-OSG: D0myseMVM1lZmeYtj_aImpmo3VNeViB9kwstDDXIKekLtqjA4fBkUswDn4S6cMWt.EYl1VfOWOo7TNEF0gJjn1AewtA0qn4rgkayig--
Date: Tue, 10 Jun 2008 05:20:49 -0700 (PDT)
From: Benjamin Kidwell <benjkidwell@yahoo.com>
Subject: Re: Linux-next Alsa hda_intel events/0 high CPU usage, bisected
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <s5hk5h1shys.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <657223.15460.qm@web53708.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- Takashi Iwai <> wrote:
>Try to run
>
>	# echo 32 > /sys/modules/snd_hda_intel/parameters/bdl_pos_adj
>and test again.

Thanks, I think that value must be just about perfect! Tested as follows:

(kill gdm)
#modprobe -r snd_hda_intel
#modprobe snd_hda_intel
#echo 32 > /sys/module/snd_hda_intel/bdl_pos_adj
(restart gdm, start playing sound)

That caused events/0 CPU% to return to almost nothing and the XXX hda delay
output did not trigger. I assume this means the latency has disappeared. For
comparison, I repeated the above processand returned bdl_pos_adj to 1, and the
delay printks reappeared and events/0 started showing significant cpu usage
again. Another reset of the driver and I reset bdl_pos_adj to 32 -- no delay
printks, almost no events/0 activity apparent.

So setting bdl_pos_adj to 32 with all new patches applied makes everything
perfect so far as I can tell. Thanks for the fix-ups for my buggy hardware,
and for reminding me to use reply and Cc: correctly. Let me know if there's
anything else I should test.
Ben


      
