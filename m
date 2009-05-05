Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbZEEHwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbZEEHwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 03:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZEEHvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 03:51:40 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:35913 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbZEEHvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 03:51:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=eUku9q1svFj7OV0TUELMPqdt1mp0TyYgV/HEQXrg/xDijcEMz8hjes6mtjEmYc10Yq
         qX57EDNS9MM4mWbjW/WeLmq5iELvQ0J+R14WYLwRTcl5Rf7WoxKuvVdkryvSV+MN8bv+
         SiDq9Bl79Wk9ys8V0Ss2rzSbmHmEtIqQjl6ms=
MIME-Version: 1.0
Date: Tue, 5 May 2009 09:51:38 +0200
X-Google-Sender-Auth: aceff5f78425225f
Message-ID: <10f740e80905050051q37524c4dv5d33b501b704b3b0@mail.gmail.com>
Subject: drivers/scsi/st.c:2967: warning: suggest parentheses around operand 
	of '!' or change '|' to '||' or '!' to '~'
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: scsi <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/scsi/st.c:2967: warning: suggest parentheses around operand of
'!' or change '|' to '||' or '!' to '~'

        if (cmdstatp->sense_hdr.sense_key == ILLEGAL_REQUEST &&
            !(STp->use_pf & PF_TESTED)) {
                /* Try the other possible state of Page Format if not
                   already tried */
                STp->use_pf = !STp->use_pf | PF_TESTED;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                st_release_request(SRpnt);
                SRpnt = NULL;
                return st_int_ioctl(STp, cmd_in, arg);
        }

Looks indeed incorrect to me...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
