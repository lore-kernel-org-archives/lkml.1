Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbZFZH0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbZFZH0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZFZH0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:26:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:56175 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbZFZH0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VD40b18SCN1VI1U2pqNM6VRcwPoi0fVLfAOH0ad+49M1oCn6HzoyLEjFTk40ZApugN
         vsxWP+Ul68U8uBdVLVjMMpL1JHXFDf+8Yg/LioaUdngIUDHdHW1NQtcdo5a3vbz1mSGJ
         80KRLXY8T5YNrKIDjLrCPfHgFOD0GzUmmfM40=
MIME-Version: 1.0
In-Reply-To: <878wkhyqj3.fsf@frosties.localdomain>
References: <20090521161317.GU1376@blitiri.com.ar>
	 <87my91qsn4.fsf@frosties.localdomain>
	 <20090525174630.GI1376@blitiri.com.ar>
	 <8763fop31e.fsf@frosties.localdomain>
	 <20090526125252.GL1376@blitiri.com.ar>
	 <878wkhyqj3.fsf@frosties.localdomain>
Date: Fri, 26 Jun 2009 12:56:42 +0530
Message-ID: <37d33d830906260026t60ae1c71h981b6f3bc0165053@mail.gmail.com>
Subject: Re: [RFC PATCH] dm-csum: A new device mapper target that checks data 
	integrity
From: SandeepKsinha <sandeepksinha@gmail.com>
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Alberto Bertogli <albertito@blitiri.com.ar>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com,
       neilb@suse.de
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alberto,

+ * TODO: would it be better to have M1 and M2 apart, to improve the chances of
+ * recovery in case of a failure?
+ *

How do you guarantee consistency in case of any lost writes? Your
checksum might hold an updated value while your data block might be
lost or written to a wrong destination?

When implementing such integrity solutions, IMO, it is always
advisable to handle such error conditions else this might lead to
issues. Since, checksums  are very tightly coupled with the data and
any misleading can be quite dangerous unlike parity which can be
recovered.

Calculate the data's CRC, and compare it to the one found in M1. If they
+ *    match, the reading is successful. If not, compare it to the one found in
+ *    M2. If they match, the reading is successful;

Also, I hope by M1 and M2 you refer to the entry for a particular
block in the respective IMD sector. What kind of mechanism do you use
to determine which is younger?
Is it the timestamp or some generation count?

I assume information is per_block_entry in the IMD sectors. Which I
don't see in your implementation?
 *
+ * The imd structure consists of:
+ *   - 16 bit CRC (CCITT) (big endian)
+ *   - 16 bit flags (big endian)
+ *   - 32 bit tag

Correct me If I am missing something.

On Fri, May 29, 2009 at 12:59 AM, Goswin von Brederlow<goswin-v-b@web.de> wrote:
> Now I need to get a new harddisk so I can test this without risking
> live data. :)
>
> MfG
>        Goswin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards,
Sandeep.





 	
“To learn is to change. Education is a process that changes the learner.”
