Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbXHVHP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbXHVHP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 03:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbXHVHPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 03:15:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:24426 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbXHVHPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 03:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=qWP9My4wST7SK18SjlfoPJgpsJ+MUFFGJSSet11P5RBY7m3lCqvVSfq6K+oxNqbgoy5n7Z/MzpfXaUrGipoKVksl+gRrwN2lLSDObKXTTz7ph82skuNFMHhNuxZ8hcHoizLJuD8xhwttpGRK0zSx6vIYCgqJCspq3ZoYXc1VnJ4=
Date: Wed, 22 Aug 2007 15:14:22 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: perex@suse.cz, liam.girdwood@wolfsonmicro.com, trivial@kernel.org
Subject: [Git Patch] sound/isa/wavefront/wavefront_synth.c: Remove a lot of
	unnecessary stuffs
Message-ID: <20070822071422.GA8215@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove unnecessary white spaces, tabs, white lines, wrap lines, parenthesises,
braces, semicolons etc.

Source file size reduced:

Before:
$ ls -l sound/isa/wavefront/wavefront_synth.c
-rw-r--r-- 1 wangcong wangcong 54356 08-22 13:38 sound/isa/wavefront/wavefront_synth.c

After:
$ ls -l sound/isa/wavefront/wavefront_synth.c
-rw-r--r-- 1 wangcong wangcong 53771 08-22 15:03 sound/isa/wavefront/wavefront_synth.c

Past compiling test.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 sound/isa/wavefront/wavefront_synth.c |  638 ++++++++++++++--------------------
 1 file changed, 274 insertions(+), 364 deletions(-)

Index: linux-2.6.23-rc3-git4/sound/isa/wavefront/wavefront_synth.c
===================================================================
--- linux-2.6.23-rc3-git4.orig/sound/isa/wavefront/wavefront_synth.c
+++ linux-2.6.23-rc3-git4/sound/isa/wavefront/wavefront_synth.c
@@ -134,8 +134,8 @@ MODULE_PARM_DESC(osrun_time, "how many s
 #define STAT_CAN_WRITE		0x20
 #define STAT_INTR_WRITE		0x40
 
-static int wavefront_delete_sample (snd_wavefront_t *, int sampnum);
-static int wavefront_find_free_sample (snd_wavefront_t *);
+static int wavefront_delete_sample(snd_wavefront_t *, int sampnum);
+static int wavefront_find_free_sample(snd_wavefront_t *);
 
 struct wavefront_command {
 	int cmd;
@@ -229,14 +229,12 @@ static struct wavefront_command wavefron
 
 static const char *
 wavefront_errorstr (int errnum)
-
 {
 	int i;
 
 	for (i = 0; wavefront_errors[i].errstr; i++) {
-		if (wavefront_errors[i].errno == errnum) {
+		if (wavefront_errors[i].errno == errnum)
 			return wavefront_errors[i].errstr;
-		}
 	}
 
 	return "Unknown WaveFront error";
@@ -244,14 +242,12 @@ wavefront_errorstr (int errnum)
 
 static struct wavefront_command *
 wavefront_get_command (int cmd) 
-
 {
 	int i;
 
 	for (i = 0; wavefront_commands[i].cmd != 0; i++) {
-		if (cmd == wavefront_commands[i].cmd) {
+		if (cmd == wavefront_commands[i].cmd)
 			return &wavefront_commands[i];
-		}
 	}
 
 	return NULL;
@@ -259,57 +255,49 @@ wavefront_get_command (int cmd) 
 
 static inline int
 wavefront_status (snd_wavefront_t *dev) 
-
 {
-	return inb (dev->status_port);
+	return inb(dev->status_port);
 }
 
 static int
 wavefront_sleep (int limit)
-
 {
 	schedule_timeout_interruptible(limit);
-
 	return signal_pending(current);
 }
 
 static int
 wavefront_wait (snd_wavefront_t *dev, int mask)
-
 {
-	int             i;
+	int i;
 
 	/* Spin for a short period of time, because >99% of all
 	   requests to the WaveFront can be serviced inline like this.
 	*/
 
 	for (i = 0; i < wait_usecs; i += 5) {
-		if (wavefront_status (dev) & mask) {
+		if (wavefront_status(dev) & mask)
 			return 1;
-		}
+
 		udelay(5);
 	}
 
 	for (i = 0; i < sleep_tries; i++) {
-
-		if (wavefront_status (dev) & mask) {
+		if (wavefront_status(dev) & mask)
 			return 1;
-		}
 
-		if (wavefront_sleep (HZ/sleep_interval)) {
-			return (0);
-		}
+		if (wavefront_sleep(HZ/sleep_interval))
+			return 0;
 	}
 
-	return (0);
+	return 0;
 }
 
 static int
 wavefront_read (snd_wavefront_t *dev)
-
 {
-	if (wavefront_wait (dev, STAT_CAN_READ))
-		return inb (dev->data_port);
+	if (wavefront_wait(dev, STAT_CAN_READ))
+		return inb(dev->data_port);
 
 	DPRINT (WF_DEBUG_DATA, "read timeout.\n");
 
@@ -318,9 +306,8 @@ wavefront_read (snd_wavefront_t *dev)
 
 static int
 wavefront_write (snd_wavefront_t *dev, unsigned char data)
-
 {
-	if (wavefront_wait (dev, STAT_CAN_WRITE)) {
+	if (wavefront_wait(dev, STAT_CAN_WRITE)) {
 		outb (data, dev->data_port);
 		return 0;
 	}
@@ -333,16 +320,14 @@ wavefront_write (snd_wavefront_t *dev, u
 int
 snd_wavefront_cmd (snd_wavefront_t *dev, 
 		   int cmd, unsigned char *rbuf, unsigned char *wbuf)
-
 {
 	int ack;
 	unsigned int i;
 	int c;
 	struct wavefront_command *wfcmd;
 
-	if ((wfcmd = wavefront_get_command (cmd)) == NULL) {
-		snd_printk ("command 0x%x not supported.\n",
-			cmd);
+	if ((wfcmd = wavefront_get_command(cmd)) == NULL) {
+		snd_printk("command 0x%x not supported.\n", cmd);
 		return 1;
 	}
 
@@ -352,7 +337,7 @@ snd_wavefront_cmd (snd_wavefront_t *dev,
 	*/
 
 	if (cmd == WFC_DOWNLOAD_MULTISAMPLE) {
-		wfcmd->write_cnt = (unsigned long) rbuf;
+		wfcmd->write_cnt = (unsigned long)rbuf;
 		rbuf = NULL;
 	}
 
@@ -360,7 +345,7 @@ snd_wavefront_cmd (snd_wavefront_t *dev,
 			       cmd, wfcmd->action, wfcmd->read_cnt,
 			       wfcmd->write_cnt, wfcmd->need_ack);
     
-	if (wavefront_write (dev, cmd)) { 
+	if (wavefront_write(dev, cmd)) {
 		DPRINT ((WF_DEBUG_IO|WF_DEBUG_CMD), "cannot request "
 						     "0x%x [%s].\n",
 						     cmd, wfcmd->action);
@@ -373,7 +358,7 @@ snd_wavefront_cmd (snd_wavefront_t *dev,
 					wfcmd->write_cnt, cmd);
 
 		for (i = 0; i < wfcmd->write_cnt; i++) {
-			if (wavefront_write (dev, wbuf[i])) {
+			if (wavefront_write(dev, wbuf[i])) {
 				DPRINT (WF_DEBUG_IO, "bad write for byte "
 						      "%d of 0x%x [%s].\n",
 						      i, cmd, wfcmd->action);
@@ -392,7 +377,7 @@ snd_wavefront_cmd (snd_wavefront_t *dev,
 
 		for (i = 0; i < wfcmd->read_cnt; i++) {
 
-			if ((c = wavefront_read (dev)) == -1) {
+			if ((c = wavefront_read(dev)) == -1) {
 				DPRINT (WF_DEBUG_IO, "bad read for byte "
 						      "%d of 0x%x [%s].\n",
 						      i, cmd, wfcmd->action);
@@ -402,7 +387,7 @@ snd_wavefront_cmd (snd_wavefront_t *dev,
 			/* Now handle errors. Lots of special cases here */
 	    
 			if (c == 0xff) { 
-				if ((c = wavefront_read (dev)) == -1) {
+				if ((c = wavefront_read(dev)) == -1) {
 					DPRINT (WF_DEBUG_IO, "bad read for "
 							      "error byte at "
 							      "read byte %d "
@@ -417,7 +402,7 @@ snd_wavefront_cmd (snd_wavefront_t *dev,
 				if (c == 1 &&
 				    wfcmd->cmd == WFC_IDENTIFY_SAMPLE_TYPE) {
 					rbuf[0] = WF_ST_EMPTY;
-					return (0);
+					return 0;
 
 				} else if (c == 3 &&
 					   wfcmd->cmd == WFC_UPLOAD_PATCH) {
@@ -428,26 +413,22 @@ snd_wavefront_cmd (snd_wavefront_t *dev,
 					   wfcmd->cmd == WFC_UPLOAD_PROGRAM) {
 
 					return 1;
-
 				} else {
-
 					DPRINT (WF_DEBUG_IO, "error %d (%s) "
 							      "during "
 							      "read for byte "
 							      "%d of 0x%x "
 							      "[%s].\n",
 							      c,
-							      wavefront_errorstr (c),
+							      wavefront_errorstr(c),
 							      i, cmd,
 							      wfcmd->action);
 					return 1;
-
 				}
-		
-		} else {
+			} else {
 				rbuf[i] = c;
 			}
-			
+
 			DPRINT (WF_DEBUG_DATA, "read[%d] = 0x%x\n",i, rbuf[i]);
 		}
 	}
@@ -460,9 +441,8 @@ snd_wavefront_cmd (snd_wavefront_t *dev,
 		   of the standard value.
 		*/
 	    
-		if ((ack = wavefront_read (dev)) == 0) {
+		if ((ack = wavefront_read(dev)) == 0)
 			ack = WF_ACK;
-		}
 	
 		if (ack != WF_ACK) {
 			if (ack == -1) {
@@ -470,13 +450,12 @@ snd_wavefront_cmd (snd_wavefront_t *dev,
 						      "0x%x [%s].\n",
 						      cmd, wfcmd->action);
 				return 1;
-		
 			} else {
 				int err = -1; /* something unknown */
 
 				if (ack == 0xff) { /* explicit error */
 		    
-					if ((err = wavefront_read (dev)) == -1) {
+					if ((err = wavefront_read(dev)) == -1) {
 						DPRINT (WF_DEBUG_DATA,
 							"cannot read err "
 							"for 0x%x [%s].\n",
@@ -505,9 +484,8 @@ snd_wavefront_cmd (snd_wavefront_t *dev,
 	}
 
 	return 0;
-	
 }
-
+
 /***********************************************************************
 WaveFront data munging   
 
@@ -535,15 +513,13 @@ munge_int32 (unsigned int src,
 		*dst = src & 0x7F;  /* Mask high bit of LSB */
 		src = src >> 7;     /* Rotate Right 7 bits  */
 	                            /* Note: we leave the upper bits in place */ 
-
 		dst++;
- 	};
+	}
 	return dst;
-};
+}
 
 static int 
 demunge_int32 (unsigned char* src, int src_size)
-
 {
 	int i;
  	int outval = 0;
@@ -553,12 +529,11 @@ demunge_int32 (unsigned char* src, int s
 	}
 
 	return outval;
-};
+}
 
 static 
 unsigned char *
 munge_buf (unsigned char *src, unsigned char *dst, unsigned int dst_size)
-
 {
 	unsigned int i;
 	unsigned int last = dst_size / 2;
@@ -573,7 +548,6 @@ munge_buf (unsigned char *src, unsigned 
 static 
 unsigned char *
 demunge_buf (unsigned char *src, unsigned char *dst, unsigned int src_bytes)
-
 {
 	int i;
 	unsigned char *end = src + src_bytes;
@@ -589,14 +563,13 @@ demunge_buf (unsigned char *src, unsigne
 
 	return dst;
 }
-
+
 /***********************************************************************
 WaveFront: sample, patch and program management.
 ***********************************************************************/
 
 static int
 wavefront_delete_sample (snd_wavefront_t *dev, int sample_num)
-
 {
 	unsigned char wbuf[2];
 	int x;
@@ -604,24 +577,22 @@ wavefront_delete_sample (snd_wavefront_t
 	wbuf[0] = sample_num & 0x7f;
 	wbuf[1] = sample_num >> 7;
 
-	if ((x = snd_wavefront_cmd (dev, WFC_DELETE_SAMPLE, NULL, wbuf)) == 0) {
+	if ((x = snd_wavefront_cmd(dev, WFC_DELETE_SAMPLE, NULL, wbuf)) == 0)
 		dev->sample_status[sample_num] = WF_ST_EMPTY;
-	}
 
 	return x;
 }
 
 static int
 wavefront_get_sample_status (snd_wavefront_t *dev, int assume_rom)
-
 {
 	int i;
 	unsigned char rbuf[32], wbuf[32];
-	unsigned int    sc_real, sc_alias, sc_multi;
+	unsigned int sc_real, sc_alias, sc_multi;
 
 	/* check sample status */
     
-	if (snd_wavefront_cmd (dev, WFC_GET_NSAMPLES, rbuf, wbuf)) {
+	if (snd_wavefront_cmd(dev, WFC_GET_NSAMPLES, rbuf, wbuf)) {
 		snd_printk ("cannot request sample count.\n");
 		return -1;
 	} 
@@ -629,11 +600,10 @@ wavefront_get_sample_status (snd_wavefro
 	sc_real = sc_alias = sc_multi = dev->samples_used = 0;
     
 	for (i = 0; i < WF_MAX_SAMPLE; i++) {
-	
 		wbuf[0] = i & 0x7f;
 		wbuf[1] = i >> 7;
 
-		if (snd_wavefront_cmd (dev, WFC_IDENTIFY_SAMPLE_TYPE, rbuf, wbuf)) {
+		if (snd_wavefront_cmd(dev, WFC_IDENTIFY_SAMPLE_TYPE, rbuf, wbuf)) {
 			snd_printk("cannot identify sample "
 				   "type of slot %d\n", i);
 			dev->sample_status[i] = WF_ST_EMPTY;
@@ -642,9 +612,8 @@ wavefront_get_sample_status (snd_wavefro
 
 		dev->sample_status[i] = (WF_SLOT_FILLED|rbuf[0]);
 
-		if (assume_rom) {
+		if (assume_rom)
 			dev->sample_status[i] |= WF_SLOT_ROM;
-		}
 
 		switch (rbuf[0] & WF_ST_MASK) {
 		case WF_ST_SAMPLE:
@@ -665,23 +634,19 @@ wavefront_get_sample_status (snd_wavefro
 				    i, rbuf[0]);
 		}
 
-		if (rbuf[0] != WF_ST_EMPTY) {
+		if (rbuf[0] != WF_ST_EMPTY)
 			dev->samples_used++;
-		} 
 	}
 
-	snd_printk ("%d samples used (%d real, %d aliases, %d multi), "
-		    "%d empty\n", dev->samples_used, sc_real, sc_alias, sc_multi,
+	snd_printk("%d samples used (%d real, %d aliases, %d multi), "
+		   "%d empty\n", dev->samples_used, sc_real, sc_alias, sc_multi,
 		    WF_MAX_SAMPLE - dev->samples_used);
 
-
-	return (0);
-
+	return 0;
 }
 
 static int
 wavefront_get_patch_status (snd_wavefront_t *dev)
-
 {
 	unsigned char patchbuf[WF_PATCH_BYTES];
 	unsigned char patchnum[2];
@@ -692,11 +657,11 @@ wavefront_get_patch_status (snd_wavefron
 		patchnum[0] = i & 0x7f;
 		patchnum[1] = i >> 7;
 
-		if ((x = snd_wavefront_cmd (dev, WFC_UPLOAD_PATCH, patchbuf,
+		if ((x = snd_wavefront_cmd(dev, WFC_UPLOAD_PATCH, patchbuf,
 					patchnum)) == 0) {
 
 			dev->patch_status[i] |= WF_SLOT_FILLED;
-			p = (wavefront_patch *) patchbuf;
+			p = (wavefront_patch *)patchbuf;
 			dev->sample_status
 				[p->sample_number|(p->sample_msb<<7)] |=
 				WF_SLOT_USED;
@@ -714,22 +679,19 @@ wavefront_get_patch_status (snd_wavefron
 	/* program status has already filled in slot_used bits */
 
 	for (i = 0, cnt = 0, cnt2 = 0; i < WF_MAX_PATCH; i++) {
-		if (dev->patch_status[i] & WF_SLOT_FILLED) {
+		if (dev->patch_status[i] & WF_SLOT_FILLED)
 			cnt++;
-		}
-		if (dev->patch_status[i] & WF_SLOT_USED) {
+
+		if (dev->patch_status[i] & WF_SLOT_USED)
 			cnt2++;
-		}
-	
 	}
-	snd_printk ("%d patch slots filled, %d in use\n", cnt, cnt2);
+	snd_printk("%d patch slots filled, %d in use\n", cnt, cnt2);
 
-	return (0);
+	return 0;
 }
 
 static int
 wavefront_get_program_status (snd_wavefront_t *dev)
-
 {
 	unsigned char progbuf[WF_PROGRAM_BYTES];
 	wavefront_program prog;
@@ -739,7 +701,7 @@ wavefront_get_program_status (snd_wavefr
 	for (i = 0; i < WF_MAX_PROGRAM; i++) {
 		prognum = i;
 
-		if ((x = snd_wavefront_cmd (dev, WFC_UPLOAD_PROGRAM, progbuf,
+		if ((x = snd_wavefront_cmd(dev, WFC_UPLOAD_PROGRAM, progbuf,
 					&prognum)) == 0) {
 
 			dev->prog_status[i] |= WF_SLOT_USED;
@@ -757,26 +719,23 @@ wavefront_get_program_status (snd_wavefr
 		} else if (x == 1) { /* Bad program number */
 			dev->prog_status[i] = 0;
 		} else {
-			snd_printk ("upload program "
-				    "error 0x%x\n", x);
+			snd_printk("upload program error 0x%x\n", x);
 			dev->prog_status[i] = 0;
 		}
 	}
 
 	for (i = 0, cnt = 0; i < WF_MAX_PROGRAM; i++) {
-		if (dev->prog_status[i]) {
+		if (dev->prog_status[i])
 			cnt++;
-		}
 	}
 
-	snd_printk ("%d programs slots in use\n", cnt);
+	snd_printk("%d programs slots in use\n", cnt);
 
-	return (0);
+	return 0;
 }
 
 static int
 wavefront_send_patch (snd_wavefront_t *dev, wavefront_patch_info *header)
-
 {
 	unsigned char buf[WF_PATCH_BYTES+2];
 	unsigned char *bptr;
@@ -787,20 +746,19 @@ wavefront_send_patch (snd_wavefront_t *d
 	dev->patch_status[header->number] |= WF_SLOT_FILLED;
 
 	bptr = buf;
-	bptr = munge_int32 (header->number, buf, 2);
-	munge_buf ((unsigned char *)&header->hdr.p, bptr, WF_PATCH_BYTES);
+	bptr = munge_int32(header->number, buf, 2);
+	munge_buf((unsigned char *)&header->hdr.p, bptr, WF_PATCH_BYTES);
     
-	if (snd_wavefront_cmd (dev, WFC_DOWNLOAD_PATCH, NULL, buf)) {
+	if (snd_wavefront_cmd(dev, WFC_DOWNLOAD_PATCH, NULL, buf)) {
 		snd_printk ("download patch failed\n");
-		return -(EIO);
+		return -EIO;
 	}
 
-	return (0);
+	return 0;
 }
 
 static int
 wavefront_send_program (snd_wavefront_t *dev, wavefront_patch_info *header)
-
 {
 	unsigned char buf[WF_PROGRAM_BYTES+1];
 	int i;
@@ -826,27 +784,26 @@ wavefront_send_program (snd_wavefront_t 
 	}
 
 	buf[0] = header->number;
-	munge_buf ((unsigned char *)&header->hdr.pr, &buf[1], WF_PROGRAM_BYTES);
+	munge_buf((unsigned char *)&header->hdr.pr, &buf[1], WF_PROGRAM_BYTES);
     
-	if (snd_wavefront_cmd (dev, WFC_DOWNLOAD_PROGRAM, NULL, buf)) {
+	if (snd_wavefront_cmd(dev, WFC_DOWNLOAD_PROGRAM, NULL, buf)) {
 		snd_printk ("download patch failed\n");	
-		return -(EIO);
+		return -EIO;
 	}
 
-	return (0);
+	return 0;
 }
 
 static int
 wavefront_freemem (snd_wavefront_t *dev)
-
 {
 	char rbuf[8];
 
-	if (snd_wavefront_cmd (dev, WFC_REPORT_FREE_MEMORY, rbuf, NULL)) {
-		snd_printk ("can't get memory stats.\n");
+	if (snd_wavefront_cmd(dev, WFC_REPORT_FREE_MEMORY, rbuf, NULL)) {
+		snd_printk("can't get memory stats.\n");
 		return -1;
 	} else {
-		return demunge_int32 (rbuf, 4);
+		return demunge_int32(rbuf, 4);
 	}
 }
 
@@ -855,7 +812,6 @@ wavefront_send_sample (snd_wavefront_t *
 		       wavefront_patch_info *header,
 		       u16 __user *dataptr,
 		       int data_is_unsigned)
-
 {
 	/* samples are downloaded via a 16-bit wide i/o port
 	   (you could think of it as 2 adjacent 8-bit wide ports
@@ -890,10 +846,10 @@ wavefront_send_sample (snd_wavefront_t *
 	if (header->number == WAVEFRONT_FIND_FREE_SAMPLE_SLOT) {
 		int x;
 
-		if ((x = wavefront_find_free_sample (dev)) < 0) {
+		if ((x = wavefront_find_free_sample(dev)) < 0)
 			return -ENOMEM;
-		}
-		snd_printk ("unspecified sample => %d\n", x);
+
+		snd_printk("unspecified sample => %d\n", x);
 		header->number = x;
 	}
 
@@ -924,21 +880,21 @@ wavefront_send_sample (snd_wavefront_t *
 
 		if (dev->rom_samples_rdonly) {
 			if (dev->sample_status[header->number] & WF_SLOT_ROM) {
-				snd_printk ("sample slot %d "
+				snd_printk("sample slot %d "
 					    "write protected\n",
 					    header->number);
 				return -EACCES;
 			}
 		}
 
-		wavefront_delete_sample (dev, header->number);
+		wavefront_delete_sample(dev, header->number);
 	}
 
 	if (header->size) {
-		dev->freemem = wavefront_freemem (dev);
+		dev->freemem = wavefront_freemem(dev);
 
 		if (dev->freemem < (int)header->size) {
-			snd_printk ("insufficient memory to "
+			snd_printk("insufficient memory to "
 				    "load %d byte sample.\n",
 				    header->size);
 			return -ENOMEM;
@@ -949,9 +905,9 @@ wavefront_send_sample (snd_wavefront_t *
 	skip = WF_GET_CHANNEL(&header->hdr.s);
 
 	if (skip > 0 && header->hdr.s.SampleResolution != LINEAR_16BIT) {
-		snd_printk ("channel selection only "
+		snd_printk("channel selection only "
 			    "possible on 16-bit samples");
-		return -(EINVAL);
+		return -EINVAL;
 	}
 
 	switch (skip) {
@@ -1008,23 +964,23 @@ wavefront_send_sample (snd_wavefront_t *
 
 	shptr = &sample_hdr[0];
 
-	shptr = munge_int32 (header->number, shptr, 2);
+	shptr = munge_int32(header->number, shptr, 2);
 
 	if (header->size) {
-		shptr = munge_int32 (length, shptr, 4);
+		shptr = munge_int32(length, shptr, 4);
 	}
 
 	/* Yes, a 4 byte result doesn't contain all of the offset bits,
 	   but the offset only uses 24 bits.
 	*/
 
-	shptr = munge_int32 (*((u32 *) &header->hdr.s.sampleStartOffset),
+	shptr = munge_int32(*((u32 *)&header->hdr.s.sampleStartOffset),
 			     shptr, 4);
-	shptr = munge_int32 (*((u32 *) &header->hdr.s.loopStartOffset),
+	shptr = munge_int32(*((u32 *)&header->hdr.s.loopStartOffset),
 			     shptr, 4);
-	shptr = munge_int32 (*((u32 *) &header->hdr.s.loopEndOffset),
+	shptr = munge_int32(*((u32 *)&header->hdr.s.loopEndOffset),
 			     shptr, 4);
-	shptr = munge_int32 (*((u32 *) &header->hdr.s.sampleEndOffset),
+	shptr = munge_int32(*((u32 *)&header->hdr.s.sampleEndOffset),
 			     shptr, 4);
 	
 	/* This one is truly weird. What kind of weirdo decided that in
@@ -1032,28 +988,27 @@ wavefront_send_sample (snd_wavefront_t *
 	   a just 12 bits ?
 	*/
 	
-	shptr = munge_int32 (header->hdr.s.FrequencyBias, shptr, 3);
+	shptr = munge_int32(header->hdr.s.FrequencyBias, shptr, 3);
 	
 	/* Why is this nybblified, when the MSB is *always* zero ? 
 	   Anyway, we can't take address of bitfield, so make a
 	   good-faith guess at where it starts.
 	*/
 	
-	shptr = munge_int32 (*(&header->hdr.s.FrequencyBias+1),
+	shptr = munge_int32(*(&header->hdr.s.FrequencyBias+1),
 			     shptr, 2);
 
-	if (snd_wavefront_cmd (dev, 
+	if (snd_wavefront_cmd(dev,
 			   header->size ?
 			   WFC_DOWNLOAD_SAMPLE : WFC_DOWNLOAD_SAMPLE_HEADER,
 			   NULL, sample_hdr)) {
-		snd_printk ("sample %sdownload refused.\n",
+		snd_printk("sample %sdownload refused.\n",
 			    header->size ? "" : "header ");
-		return -(EIO);
+		return -EIO;
 	}
 
-	if (header->size == 0) {
+	if (header->size == 0)
 		goto sent; /* Sorry. Just had to have one somewhere */
-	}
     
 	data_end = dataptr + length;
 
@@ -1071,21 +1026,19 @@ wavefront_send_sample (snd_wavefront_t *
 			blocksize = ALIGN(length - written, 8);
 		}
 
-		if (snd_wavefront_cmd (dev, WFC_DOWNLOAD_BLOCK, NULL, NULL)) {
-			snd_printk ("download block "
+		if (snd_wavefront_cmd(dev, WFC_DOWNLOAD_BLOCK, NULL, NULL)) {
+			snd_printk("download block "
 				    "request refused.\n");
-			return -(EIO);
+			return -EIO;
 		}
 
 		for (i = 0; i < blocksize; i++) {
 
 			if (dataptr < data_end) {
-		
-				__get_user (sample_short, dataptr);
+				__get_user(sample_short, dataptr);
 				dataptr += skip;
 		
 				if (data_is_unsigned) { /* GUS ? */
-
 					if (WF_SAMPLE_IS_8BIT(&header->hdr.s)) {
 			
 						/* 8 bit sample
@@ -1097,7 +1050,6 @@ wavefront_send_sample (snd_wavefront_t *
 						 &sample_short)[0] += 0x7f;
 						((unsigned char*)
 						 &sample_short)[1] += 0x7f;
-			
 					} else {
 			
 						/* 16 bit sample
@@ -1108,7 +1060,6 @@ wavefront_send_sample (snd_wavefront_t *
 						sample_short += 0x7fff;
 					}
 				}
-
 			} else {
 
 				/* In padding section of final block:
@@ -1120,9 +1071,9 @@ wavefront_send_sample (snd_wavefront_t *
 			}
 	    
 			if (i < blocksize - 1) {
-				outw (sample_short, dev->block_port);
+				outw(sample_short, dev->block_port);
 			} else {
-				outw (sample_short, dev->last_block_port);
+				outw(sample_short, dev->last_block_port);
 			}
 		}
 
@@ -1130,16 +1081,16 @@ wavefront_send_sample (snd_wavefront_t *
 		   nothing to do with DMA at all.
 		*/
 	
-		if ((dma_ack = wavefront_read (dev)) != WF_DMA_ACK) {
+		if ((dma_ack = wavefront_read(dev)) != WF_DMA_ACK) {
 			if (dma_ack == -1) {
-				snd_printk ("upload sample "
+				snd_printk("upload sample "
 					    "DMA ack timeout\n");
-				return -(EIO);
+				return -EIO;
 			} else {
-				snd_printk ("upload sample "
+				snd_printk("upload sample "
 					    "DMA ack error 0x%x\n",
 					    dma_ack);
-				return -(EIO);
+				return -EIO;
 			}
 		}
 	}
@@ -1151,12 +1102,11 @@ wavefront_send_sample (snd_wavefront_t *
 	*/
 
  sent:
-	return (0);
+	return 0;
 }
 
 static int
 wavefront_send_alias (snd_wavefront_t *dev, wavefront_patch_info *header)
-
 {
 	unsigned char alias_hdr[WF_ALIAS_BYTES];
 
@@ -1165,27 +1115,27 @@ wavefront_send_alias (snd_wavefront_t *d
 				      header->number,
 				      header->hdr.a.OriginalSample);
     
-	munge_int32 (header->number, &alias_hdr[0], 2);
-	munge_int32 (header->hdr.a.OriginalSample, &alias_hdr[2], 2);
-	munge_int32 (*((unsigned int *)&header->hdr.a.sampleStartOffset),
+	munge_int32(header->number, &alias_hdr[0], 2);
+	munge_int32(header->hdr.a.OriginalSample, &alias_hdr[2], 2);
+	munge_int32(*((unsigned int *)&header->hdr.a.sampleStartOffset),
 		     &alias_hdr[4], 4);
-	munge_int32 (*((unsigned int *)&header->hdr.a.loopStartOffset),
+	munge_int32(*((unsigned int *)&header->hdr.a.loopStartOffset),
 		     &alias_hdr[8], 4);
-	munge_int32 (*((unsigned int *)&header->hdr.a.loopEndOffset),
+	munge_int32(*((unsigned int *)&header->hdr.a.loopEndOffset),
 		     &alias_hdr[12], 4);
-	munge_int32 (*((unsigned int *)&header->hdr.a.sampleEndOffset),
+	munge_int32(*((unsigned int *)&header->hdr.a.sampleEndOffset),
 		     &alias_hdr[16], 4);
-	munge_int32 (header->hdr.a.FrequencyBias, &alias_hdr[20], 3);
-	munge_int32 (*(&header->hdr.a.FrequencyBias+1), &alias_hdr[23], 2);
+	munge_int32(header->hdr.a.FrequencyBias, &alias_hdr[20], 3);
+	munge_int32(*(&header->hdr.a.FrequencyBias+1), &alias_hdr[23], 2);
 
-	if (snd_wavefront_cmd (dev, WFC_DOWNLOAD_SAMPLE_ALIAS, NULL, alias_hdr)) {
-		snd_printk ("download alias failed.\n");
-		return -(EIO);
+	if (snd_wavefront_cmd(dev, WFC_DOWNLOAD_SAMPLE_ALIAS, NULL, alias_hdr)) {
+		snd_printk("download alias failed.\n");
+		return -EIO;
 	}
 
 	dev->sample_status[header->number] = (WF_SLOT_FILLED|WF_ST_ALIAS);
 
-	return (0);
+	return 0;
 }
 
 static int
@@ -1196,10 +1146,10 @@ wavefront_send_multisample (snd_wavefron
 	unsigned char *msample_hdr;
 
 	msample_hdr = kmalloc(sizeof(WF_MSAMPLE_BYTES), GFP_KERNEL);
-	if (! msample_hdr)
+	if (!msample_hdr)
 		return -ENOMEM;
 
-	munge_int32 (header->number, &msample_hdr[0], 2);
+	munge_int32(header->number, &msample_hdr[0], 2);
 
 	/* You'll recall at this point that the "number of samples" value
 	   in a wavefront_multisample struct is actually the log2 of the
@@ -1207,7 +1157,7 @@ wavefront_send_multisample (snd_wavefron
 	*/
 
 	num_samples = (1<<(header->hdr.ms.NumberOfSamples&7));
-	msample_hdr[2] = (unsigned char) header->hdr.ms.NumberOfSamples;
+	msample_hdr[2] = (unsigned char)header->hdr.ms.NumberOfSamples;
 
 	DPRINT (WF_DEBUG_LOAD_PATCH, "multi %d with %d=%d samples\n",
 				      header->number,
@@ -1217,27 +1167,27 @@ wavefront_send_multisample (snd_wavefron
 	for (i = 0; i < num_samples; i++) {
 		DPRINT(WF_DEBUG_LOAD_PATCH|WF_DEBUG_DATA, "sample[%d] = %d\n",
 		       i, header->hdr.ms.SampleNumber[i]);
-		munge_int32 (header->hdr.ms.SampleNumber[i],
+		munge_int32(header->hdr.ms.SampleNumber[i],
 		     &msample_hdr[3+(i*2)], 2);
 	}
-    
+
 	/* Need a hack here to pass in the number of bytes
 	   to be written to the synth. This is ugly, and perhaps
 	   one day, I'll fix it.
 	*/
 
-	if (snd_wavefront_cmd (dev, WFC_DOWNLOAD_MULTISAMPLE, 
+	if (snd_wavefront_cmd(dev, WFC_DOWNLOAD_MULTISAMPLE,
 			   (unsigned char *) (long) ((num_samples*2)+3),
 			   msample_hdr)) {
-		snd_printk ("download of multisample failed.\n");
+		snd_printk("download of multisample failed.\n");
 		kfree(msample_hdr);
-		return -(EIO);
+		return -EIO;
 	}
 
 	dev->sample_status[header->number] = (WF_SLOT_FILLED|WF_ST_MULTISAMPLE);
 
 	kfree(msample_hdr);
-	return (0);
+	return 0;
 }
 
 static int
@@ -1249,11 +1199,11 @@ wavefront_fetch_multisample (snd_wavefro
 	unsigned char number[2];
 	int num_samples;
 
-	munge_int32 (header->number, number, 2);
+	munge_int32(header->number, number, 2);
     
-	if (snd_wavefront_cmd (dev, WFC_UPLOAD_MULTISAMPLE, log_ns, number)) {
-		snd_printk ("upload multisample failed.\n");
-		return -(EIO);
+	if (snd_wavefront_cmd(dev, WFC_UPLOAD_MULTISAMPLE, log_ns, number)) {
+		snd_printk("upload multisample failed.\n");
+		return -EIO;
 	}
     
 	DPRINT (WF_DEBUG_DATA, "msample %d has %d samples\n",
@@ -1269,34 +1219,33 @@ wavefront_fetch_multisample (snd_wavefro
 		char d[2];
 		int val;
 	
-		if ((val = wavefront_read (dev)) == -1) {
-			snd_printk ("upload multisample failed "
+		if ((val = wavefront_read(dev)) == -1) {
+			snd_printk("upload multisample failed "
 				    "during sample loop.\n");
-			return -(EIO);
+			return -EIO;
 		}
 		d[0] = val;
 
-		if ((val = wavefront_read (dev)) == -1) {
-			snd_printk ("upload multisample failed "
+		if ((val = wavefront_read(dev)) == -1) {
+			snd_printk("upload multisample failed "
 				    "during sample loop.\n");
-			return -(EIO);
+			return -EIO;
 		}
 		d[1] = val;
 	
 		header->hdr.ms.SampleNumber[i] =
-			demunge_int32 ((unsigned char *) d, 2);
+			demunge_int32((unsigned char *)d, 2);
 	
 		DPRINT (WF_DEBUG_DATA, "msample sample[%d] = %d\n",
 					i, header->hdr.ms.SampleNumber[i]);
 	}
 
-	return (0);
+	return 0;
 }
 
 
 static int
 wavefront_send_drum (snd_wavefront_t *dev, wavefront_patch_info *header)
-
 {
 	unsigned char drumbuf[WF_DRUM_BYTES];
 	wavefront_drum *drum = &header->hdr.d;
@@ -1309,20 +1258,19 @@ wavefront_send_drum (snd_wavefront_t *de
 	drumbuf[0] = header->number & 0x7f;
 
 	for (i = 0; i < 4; i++) {
-		munge_int32 (((unsigned char *)drum)[i], &drumbuf[1+(i*2)], 2);
+		munge_int32(((unsigned char *)drum)[i], &drumbuf[1+(i*2)], 2);
 	}
 
-	if (snd_wavefront_cmd (dev, WFC_DOWNLOAD_EDRUM_PROGRAM, NULL, drumbuf)) {
-		snd_printk ("download drum failed.\n");
-		return -(EIO);
+	if (snd_wavefront_cmd(dev, WFC_DOWNLOAD_EDRUM_PROGRAM, NULL, drumbuf)) {
+		snd_printk("download drum failed.\n");
+		return -EIO;
 	}
 
-	return (0);
+	return 0;
 }
 
 static int 
 wavefront_find_free_sample (snd_wavefront_t *dev)
-
 {
 	int i;
 
@@ -1331,7 +1279,7 @@ wavefront_find_free_sample (snd_wavefron
 			return i;
 		}
 	}
-	snd_printk ("no free sample slots!\n");
+	snd_printk("no free sample slots!\n");
 	return -1;
 }
 
@@ -1359,12 +1307,12 @@ wavefront_load_patch (snd_wavefront_t *d
 	int err;
 	
 	header = kmalloc(sizeof(*header), GFP_KERNEL);
-	if (! header)
+	if (!header)
 		return -ENOMEM;
 
-	if (copy_from_user (header, addr, sizeof(wavefront_patch_info) -
+	if (copy_from_user(header, addr, sizeof(wavefront_patch_info) -
 			    sizeof(wavefront_any))) {
-		snd_printk ("bad address for load patch.\n");
+		snd_printk("bad address for load patch.\n");
 		err = -EFAULT;
 		goto __error;
 	}
@@ -1380,69 +1328,69 @@ wavefront_load_patch (snd_wavefront_t *d
 	switch (header->subkey) {
 	case WF_ST_SAMPLE:  /* sample or sample_header, based on patch->size */
 
-		if (copy_from_user (&header->hdr.s, header->hdrptr,
-				    sizeof (wavefront_sample))) {
+		if (copy_from_user(&header->hdr.s, header->hdrptr,
+				    sizeof(wavefront_sample))) {
 			err = -EFAULT;
 			break;
 		}
 
-		err = wavefront_send_sample (dev, header, header->dataptr, 0);
+		err = wavefront_send_sample(dev, header, header->dataptr, 0);
 		break;
 
 	case WF_ST_MULTISAMPLE:
 
-		if (copy_from_user (&header->hdr.s, header->hdrptr,
-				    sizeof (wavefront_multisample))) {
+		if (copy_from_user(&header->hdr.s, header->hdrptr,
+				    sizeof(wavefront_multisample))) {
 			err = -EFAULT;
 			break;
 		}
 
-		err = wavefront_send_multisample (dev, header);
+		err = wavefront_send_multisample(dev, header);
 		break;
 
 	case WF_ST_ALIAS:
 
-		if (copy_from_user (&header->hdr.a, header->hdrptr,
-				    sizeof (wavefront_alias))) {
+		if (copy_from_user(&header->hdr.a, header->hdrptr,
+				    sizeof(wavefront_alias))) {
 			err = -EFAULT;
 			break;
 		}
 
-		err = wavefront_send_alias (dev, header);
+		err = wavefront_send_alias(dev, header);
 		break;
 
 	case WF_ST_DRUM:
-		if (copy_from_user (&header->hdr.d, header->hdrptr,
-				    sizeof (wavefront_drum))) {
+		if (copy_from_user(&header->hdr.d, header->hdrptr,
+				    sizeof(wavefront_drum))) {
 			err = -EFAULT;
 			break;
 		}
 
-		err = wavefront_send_drum (dev, header);
+		err = wavefront_send_drum(dev, header);
 		break;
 
 	case WF_ST_PATCH:
-		if (copy_from_user (&header->hdr.p, header->hdrptr,
-				    sizeof (wavefront_patch))) {
+		if (copy_from_user(&header->hdr.p, header->hdrptr,
+				    sizeof(wavefront_patch))) {
 			err = -EFAULT;
 			break;
 		}
 		
-		err = wavefront_send_patch (dev, header);
+		err = wavefront_send_patch(dev, header);
 		break;
 
 	case WF_ST_PROGRAM:
-		if (copy_from_user (&header->hdr.pr, header->hdrptr,
-				    sizeof (wavefront_program))) {
+		if (copy_from_user(&header->hdr.pr, header->hdrptr,
+				    sizeof(wavefront_program))) {
 			err = -EFAULT;
 			break;
 		}
 
-		err = wavefront_send_program (dev, header);
+		err = wavefront_send_program(dev, header);
 		break;
 
 	default:
-		snd_printk ("unknown patch type %d.\n",
+		snd_printk("unknown patch type %d.\n",
 			    header->subkey);
 		err = -EINVAL;
 		break;
@@ -1452,14 +1400,13 @@ wavefront_load_patch (snd_wavefront_t *d
 	kfree(header);
 	return err;
 }
-
+
 /***********************************************************************
 WaveFront: hardware-dependent interface
 ***********************************************************************/
 
 static void
 process_sample_hdr (u8 *buf)
-
 {
 	wavefront_sample s;
 	u8 *ptr;
@@ -1473,11 +1420,11 @@ process_sample_hdr (u8 *buf)
 	   something very similar in the reverse direction.
 	*/
 
-	*((u32 *) &s.sampleStartOffset) = demunge_int32 (ptr, 4); ptr += 4;
-	*((u32 *) &s.loopStartOffset) = demunge_int32 (ptr, 4); ptr += 4;
-	*((u32 *) &s.loopEndOffset) = demunge_int32 (ptr, 4); ptr += 4;
-	*((u32 *) &s.sampleEndOffset) = demunge_int32 (ptr, 4); ptr += 4;
-	*((u32 *) &s.FrequencyBias) = demunge_int32 (ptr, 3); ptr += 3;
+	*((u32 *) &s.sampleStartOffset) = demunge_int32(ptr, 4); ptr += 4;
+	*((u32 *) &s.loopStartOffset) = demunge_int32(ptr, 4); ptr += 4;
+	*((u32 *) &s.loopEndOffset) = demunge_int32(ptr, 4); ptr += 4;
+	*((u32 *) &s.sampleEndOffset) = demunge_int32(ptr, 4); ptr += 4;
+	*((u32 *) &s.FrequencyBias) = demunge_int32(ptr, 3); ptr += 3;
 
 	s.SampleResolution = *ptr & 0x3;
 	s.Loop = *ptr & 0x8;
@@ -1486,13 +1433,12 @@ process_sample_hdr (u8 *buf)
 
 	/* Now copy it back to where it came from */
 
-	memcpy (buf, (unsigned char *) &s, sizeof (wavefront_sample));
+	memcpy(buf, (unsigned char *)&s, sizeof(wavefront_sample));
 }
 
 static int
 wavefront_synth_control (snd_wavefront_card_t *acard, 
 			 wavefront_control *wc)
-
 {
 	snd_wavefront_t *dev = &acard->wavefront;
 	unsigned char patchnumbuf[2];
@@ -1504,16 +1450,15 @@ wavefront_synth_control (snd_wavefront_c
 	/* Pre-handling of or for various commands */
 
 	switch (wc->cmd) {
-		
 	case WFC_DISABLE_INTERRUPTS:
-		snd_printk ("interrupts disabled.\n");
-		outb (0x80|0x20, dev->control_port);
+		snd_printk("interrupts disabled.\n");
+		outb(0x80|0x20, dev->control_port);
 		dev->interrupts_are_midi = 1;
 		return 0;
 
 	case WFC_ENABLE_INTERRUPTS:
-		snd_printk ("interrupts enabled.\n");
-		outb (0x80|0x40|0x20, dev->control_port);
+		snd_printk("interrupts enabled.\n");
+		outb(0x80|0x40|0x20, dev->control_port);
 		dev->interrupts_are_midi = 1;
 		return 0;
 
@@ -1529,8 +1474,7 @@ wavefront_synth_control (snd_wavefront_c
 	case WFC_IDENTIFY_SLOT_TYPE:
 		i = wc->wbuf[0] | (wc->wbuf[1] << 7);
 		if (i <0 || i >= WF_MAX_SAMPLE) {
-			snd_printk ("invalid slot ID %d\n",
-				i);
+			snd_printk("invalid slot ID %d\n", i);
 			wc->status = EINVAL;
 			return -EINVAL;
 		}
@@ -1540,12 +1484,12 @@ wavefront_synth_control (snd_wavefront_c
 
 	case WFC_DEBUG_DRIVER:
 		dev->debug = wc->wbuf[0];
-		snd_printk ("debug = 0x%x\n", dev->debug);
+		snd_printk("debug = 0x%x\n", dev->debug);
 		return 0;
 
 	case WFC_UPLOAD_PATCH:
-		munge_int32 (*((u32 *) wc->wbuf), patchnumbuf, 2);
-		memcpy (wc->wbuf, patchnumbuf, 2);
+		munge_int32(*((u32 *) wc->wbuf), patchnumbuf, 2);
+		memcpy(wc->wbuf, patchnumbuf, 2);
 		break;
 
 	case WFC_UPLOAD_MULTISAMPLE:
@@ -1557,13 +1501,13 @@ wavefront_synth_control (snd_wavefront_c
 		return 0;
 
 	case WFC_UPLOAD_SAMPLE_ALIAS:
-		snd_printk ("support for sample alias upload "
+		snd_printk("support for sample alias upload "
 			"being considered.\n");
 		wc->status = EINVAL;
 		return -EINVAL;
 	}
 
-	wc->status = snd_wavefront_cmd (dev, wc->cmd, wc->rbuf, wc->wbuf);
+	wc->status = snd_wavefront_cmd(dev, wc->cmd, wc->rbuf, wc->wbuf);
 
 	/* Post-handling of certain commands.
 
@@ -1579,37 +1523,37 @@ wavefront_synth_control (snd_wavefront_c
 			*/
 
 		case WFC_REPORT_FREE_MEMORY:
-			dev->freemem = demunge_int32 (wc->rbuf, 4);
+			dev->freemem = demunge_int32(wc->rbuf, 4);
 			break;
 
 		case WFC_UPLOAD_PATCH:
-			demunge_buf (wc->rbuf, wc->rbuf, WF_PATCH_BYTES);
+			demunge_buf(wc->rbuf, wc->rbuf, WF_PATCH_BYTES);
 			break;
 
 		case WFC_UPLOAD_PROGRAM:
-			demunge_buf (wc->rbuf, wc->rbuf, WF_PROGRAM_BYTES);
+			demunge_buf(wc->rbuf, wc->rbuf, WF_PROGRAM_BYTES);
 			break;
 
 		case WFC_UPLOAD_EDRUM_PROGRAM:
-			demunge_buf (wc->rbuf, wc->rbuf, WF_DRUM_BYTES - 1);
+			demunge_buf(wc->rbuf, wc->rbuf, WF_DRUM_BYTES - 1);
 			break;
 
 		case WFC_UPLOAD_SAMPLE_HEADER:
-			process_sample_hdr (wc->rbuf);
+			process_sample_hdr(wc->rbuf);
 			break;
 
 		case WFC_UPLOAD_SAMPLE_ALIAS:
-			snd_printk ("support for "
+			snd_printk("support for "
 				    "sample aliases still "
 				    "being considered.\n");
 			break;
 
 		case WFC_VMIDI_OFF:
-			snd_wavefront_midi_disable_virtual (acard);
+			snd_wavefront_midi_disable_virtual(acard);
 			break;
 
 		case WFC_VMIDI_ON:
-			snd_wavefront_midi_enable_virtual (acard);
+			snd_wavefront_midi_enable_virtual(acard);
 			break;
 		}
 	}
@@ -1619,7 +1563,6 @@ wavefront_synth_control (snd_wavefront_c
 
 int 
 snd_wavefront_synth_open (struct snd_hwdep *hw, struct file *file)
-
 {
 	if (!try_module_get(hw->card->module))
 		return -EFAULT;
@@ -1629,7 +1572,6 @@ snd_wavefront_synth_open (struct snd_hwd
 
 int 
 snd_wavefront_synth_release (struct snd_hwdep *hw, struct file *file)
-
 {
 	module_put(hw->card->module);
 	return 0;
@@ -1638,7 +1580,6 @@ snd_wavefront_synth_release (struct snd_
 int
 snd_wavefront_synth_ioctl (struct snd_hwdep *hw, struct file *file,
 			   unsigned int cmd, unsigned long arg)
-
 {
 	struct snd_card *card;
 	snd_wavefront_t *dev;
@@ -1647,7 +1588,7 @@ snd_wavefront_synth_ioctl (struct snd_hw
 	void __user *argp = (void __user *)arg;
 	int err;
 
-	card = (struct snd_card *) hw->card;
+	card = (struct snd_card *)hw->card;
 
 	snd_assert(card != NULL, return -ENODEV);
 
@@ -1658,20 +1599,19 @@ snd_wavefront_synth_ioctl (struct snd_hw
 	
 	switch (cmd) {
 	case WFCTL_LOAD_SPP:
-		if (wavefront_load_patch (dev, argp) != 0) {
+		if (wavefront_load_patch(dev, argp) != 0)
 			return -EIO;
-		}
 		break;
 
 	case WFCTL_WFCMD:
 		wc = kmalloc(sizeof(*wc), GFP_KERNEL);
-		if (! wc)
+		if (!wc)
 			return -ENOMEM;
-		if (copy_from_user (wc, argp, sizeof (*wc)))
+		if (copy_from_user(wc, argp, sizeof(*wc)))
 			err = -EFAULT;
-		else if (wavefront_synth_control (acard, wc) < 0)
+		else if (wavefront_synth_control(acard, wc) < 0)
 			err = -EIO;
-		else if (copy_to_user (argp, wc, sizeof (*wc)))
+		else if (copy_to_user(argp, wc, sizeof(*wc)))
 			err = -EFAULT;
 		else
 			err = 0;
@@ -1685,7 +1625,6 @@ snd_wavefront_synth_ioctl (struct snd_hw
 	return 0;
 }
 
-
 /***********************************************************************/
 /*  WaveFront: interface for card-level wavefront module               */
 /***********************************************************************/
@@ -1740,7 +1679,6 @@ snd_wavefront_internal_interrupt (snd_wa
 
 static int __devinit
 snd_wavefront_interrupt_bits (int irq)
-
 {
 	int bits;
 
@@ -1759,7 +1697,7 @@ snd_wavefront_interrupt_bits (int irq)
 		break;
 	
 	default:
-		snd_printk ("invalid IRQ %d\n", irq);
+		snd_printk("invalid IRQ %d\n", irq);
 		bits = -1;
 	}
 
@@ -1769,7 +1707,6 @@ snd_wavefront_interrupt_bits (int irq)
 static void __devinit
 wavefront_should_cause_interrupt (snd_wavefront_t *dev, 
 				  int val, int port, int timeout)
-
 {
 	wait_queue_t wait;
 
@@ -1777,7 +1714,7 @@ wavefront_should_cause_interrupt (snd_wa
 	spin_lock_irq(&dev->irq_lock);
 	add_wait_queue(&dev->interrupt_sleeper, &wait);
 	dev->irq_ok = 0;
-	outb (val,port);
+	outb(val, port);
 	spin_unlock_irq(&dev->irq_lock);
 	while (1) {
 		if ((timeout = schedule_timeout(timeout)) == 0)
@@ -1789,18 +1726,17 @@ wavefront_should_cause_interrupt (snd_wa
 
 static int __devinit
 wavefront_reset_to_cleanliness (snd_wavefront_t *dev)
-
 {
 	int bits;
 	int hwv[2];
 
 	/* IRQ already checked */
 
-	bits = snd_wavefront_interrupt_bits (dev->irq);
+	bits = snd_wavefront_interrupt_bits(dev->irq);
 
 	/* try reset of port */
 
-	outb (0x0, dev->control_port); 
+	outb(0x0, dev->control_port);
   
 	/* At this point, the board is in reset, and the H/W initialization
 	   register is accessed at the same address as the data port.
@@ -1838,7 +1774,7 @@ wavefront_reset_to_cleanliness (snd_wave
 	   plus external 9-pin MIDI interface selected
 	*/
 
-	outb (0x80 | 0x40 | bits, dev->data_port);	
+	outb(0x80 | 0x40 | bits, dev->data_port);
   
 	/* CONTROL REGISTER
 
@@ -1866,7 +1802,7 @@ wavefront_reset_to_cleanliness (snd_wave
 	 */
 
 	if (!dev->irq_ok) {
-		snd_printk ("intr not received after h/w un-reset.\n");
+		snd_printk("intr not received after h/w un-reset.\n");
 		goto gone_bad;
 	} 
 
@@ -1890,17 +1826,17 @@ wavefront_reset_to_cleanliness (snd_wave
 					 dev->data_port, ramcheck_time*HZ);
 
 	if (!dev->irq_ok) {
-		snd_printk ("post-RAM-check interrupt not received.\n");
+		snd_printk("post-RAM-check interrupt not received.\n");
 		goto gone_bad;
 	} 
 
-	if (!wavefront_wait (dev, STAT_CAN_READ)) {
-		snd_printk ("no response to HW version cmd.\n");
+	if (!wavefront_wait(dev, STAT_CAN_READ)) {
+		snd_printk("no response to HW version cmd.\n");
 		goto gone_bad;
 	}
-	
-	if ((hwv[0] = wavefront_read (dev)) == -1) {
-		snd_printk ("board not responding correctly.\n");
+
+	if ((hwv[0] = wavefront_read(dev)) == -1) {
+		snd_printk("board not responding correctly.\n");
 		goto gone_bad;
 	}
 
@@ -1909,33 +1845,30 @@ wavefront_reset_to_cleanliness (snd_wave
 		/* Board's RAM test failed. Try to read error code,
 		   and tell us about it either way.
 		*/
-		
-		if ((hwv[0] = wavefront_read (dev)) == -1) {
-			snd_printk ("on-board RAM test failed "
+
+		if ((hwv[0] = wavefront_read(dev)) == -1) {
+			snd_printk("on-board RAM test failed "
 				    "(bad error code).\n");
 		} else {
-			snd_printk ("on-board RAM test failed "
-				    "(error code: 0x%x).\n",
-				hwv[0]);
+			snd_printk("on-board RAM test failed "
+				    "(error code: 0x%x).\n", hwv[0]);
 		}
 		goto gone_bad;
 	}
 
 	/* We're OK, just get the next byte of the HW version response */
 
-	if ((hwv[1] = wavefront_read (dev)) == -1) {
-		snd_printk ("incorrect h/w response.\n");
+	if ((hwv[1] = wavefront_read(dev)) == -1) {
+		snd_printk("incorrect h/w response.\n");
 		goto gone_bad;
 	}
 
-	snd_printk ("hardware version %d.%d\n",
-		    hwv[0], hwv[1]);
+	snd_printk("hardware version %d.%d\n", hwv[0], hwv[1]);
 
 	return 0;
 
-
      gone_bad:
-	return (1);
+	return 1;
 }
 
 #include <linux/fs.h>
@@ -1948,7 +1881,6 @@ wavefront_reset_to_cleanliness (snd_wave
 
 static int __devinit
 wavefront_download_firmware (snd_wavefront_t *dev, char *path)
-
 {
 	unsigned char section[WF_SECTION_MAX];
 	signed char section_length; /* yes, just a char; max value is WF_SECTION_MAX */
@@ -1969,20 +1901,19 @@ wavefront_download_firmware (snd_wavefro
 	*/
 
 	fs = get_fs();
-	set_fs (get_ds());
+	set_fs(get_ds());
 
-	if ((fd = sys_open ((char __user *) path, 0, 0)) < 0) {
-		snd_printk ("Unable to load \"%s\".\n",
-			path);
+	if ((fd = sys_open((char __user *)path, 0, 0)) < 0) {
+		snd_printk("Unable to load \"%s\".\n", path);
 		return 1;
 	}
 
 	while (1) {
 		int x;
 
-		if ((x = sys_read (fd, (char __user *) &section_length, sizeof (section_length))) !=
-		    sizeof (section_length)) {
-			snd_printk ("firmware read error.\n");
+		if ((x = sys_read(fd, (char __user *)&section_length, sizeof(section_length))) !=
+		    sizeof(section_length)) {
+			snd_printk("firmware read error.\n");
 			goto failure;
 		}
 
@@ -1991,77 +1922,67 @@ wavefront_download_firmware (snd_wavefro
 		}
 
 		if (section_length < 0 || section_length > WF_SECTION_MAX) {
-			snd_printk ("invalid firmware section length %d\n",
+			snd_printk("invalid firmware section length %d\n",
 				    section_length);
 			goto failure;
 		}
 
-		if (sys_read (fd, (char __user *) section, section_length) != section_length) {
-			snd_printk ("firmware section "
-				"read error.\n");
+		if (sys_read(fd, (char __user *)section, section_length) != section_length) {
+			snd_printk("firmware section read error.\n");
 			goto failure;
 		}
 
 		/* Send command */
 	
-		if (wavefront_write (dev, WFC_DOWNLOAD_OS)) {
+		if (wavefront_write(dev, WFC_DOWNLOAD_OS))
 			goto failure;
-		}
 	
 		for (i = 0; i < section_length; i++) {
-			if (wavefront_write (dev, section[i])) {
+			if (wavefront_write(dev, section[i]))
 				goto failure;
-			}
 		}
 	
 		/* get ACK */
 	
-		if (wavefront_wait (dev, STAT_CAN_READ)) {
-
-			if ((c = inb (dev->data_port)) != WF_ACK) {
-
-				snd_printk ("download "
+		if (wavefront_wait(dev, STAT_CAN_READ)) {
+			if ((c = inb(dev->data_port)) != WF_ACK) {
+				snd_printk("download "
 					    "of section #%d not "
 					    "acknowledged, ack = 0x%x\n",
 					    section_cnt_downloaded + 1, c);
 				goto failure;
-		
 			}
-
 		} else {
-			snd_printk ("time out for firmware ACK.\n");
+			snd_printk("time out for firmware ACK.\n");
 			goto failure;
 		}
-
 	}
 
-	sys_close (fd);
-	set_fs (fs);
+	sys_close(fd);
+	set_fs(fs);
 	return 0;
 
  failure:
-	sys_close (fd);
-	set_fs (fs);
-	snd_printk ("firmware download failed!!!\n");
+	sys_close(fd);
+	set_fs(fs);
+	snd_printk("firmware download failed!!!\n");
 	return 1;
 }
 
 
 static int __devinit
 wavefront_do_reset (snd_wavefront_t *dev)
-
 {
 	char voices[1];
 
-	if (wavefront_reset_to_cleanliness (dev)) {
-		snd_printk ("hw reset failed.\n");
+	if (wavefront_reset_to_cleanliness(dev)) {
+		snd_printk("hw reset failed.\n");
 		goto gone_bad;
 	}
 
 	if (dev->israw) {
-		if (wavefront_download_firmware (dev, ospath)) {
+		if (wavefront_download_firmware(dev, ospath))
 			goto gone_bad;
-		}
 
 		dev->israw = 0;
 
@@ -2073,72 +1994,69 @@ wavefront_do_reset (snd_wavefront_t *dev
 		   Rather than using timed waits, use interrupts creatively.
 		*/
 
-		wavefront_should_cause_interrupt (dev, WFC_NOOP,
+		wavefront_should_cause_interrupt(dev, WFC_NOOP,
 						  dev->data_port,
 						  (osrun_time*HZ));
 
 		if (!dev->irq_ok) {
-			snd_printk ("no post-OS interrupt.\n");
+			snd_printk("no post-OS interrupt.\n");
 			goto gone_bad;
 		}
-		
+
 		/* Now, do it again ! */
-		
-		wavefront_should_cause_interrupt (dev, WFC_NOOP,
+
+		wavefront_should_cause_interrupt(dev, WFC_NOOP,
 						  dev->data_port, (10*HZ));
-		
+
 		if (!dev->irq_ok) {
-			snd_printk ("no post-OS interrupt(2).\n");
+			snd_printk("no post-OS interrupt(2).\n");
 			goto gone_bad;
 		}
 
 		/* OK, no (RX/TX) interrupts any more, but leave mute
 		   in effect. 
 		*/
-		
-		outb (0x80|0x40, dev->control_port); 
+
+		outb(0x80|0x40, dev->control_port);
 	}
 
 	/* SETUPSND.EXE asks for sample memory config here, but since i
 	   have no idea how to interpret the result, we'll forget
 	   about it.
 	*/
-	
-	if ((dev->freemem = wavefront_freemem (dev)) < 0) {
+
+	if ((dev->freemem = wavefront_freemem(dev)) < 0)
 		goto gone_bad;
-	}
-		
-	snd_printk ("available DRAM %dk\n", dev->freemem / 1024);
 
-	if (wavefront_write (dev, 0xf0) ||
-	    wavefront_write (dev, 1) ||
-	    (wavefront_read (dev) < 0)) {
+	snd_printk("available DRAM %dk\n", dev->freemem / 1024);
+
+	if (wavefront_write(dev, 0xf0) ||
+	    wavefront_write(dev, 1) ||
+	    (wavefront_read(dev) < 0)) {
 		dev->debug = 0;
-		snd_printk ("MPU emulation mode not set.\n");
+		snd_printk("MPU emulation mode not set.\n");
 		goto gone_bad;
 	}
 
 	voices[0] = 32;
 
-	if (snd_wavefront_cmd (dev, WFC_SET_NVOICES, NULL, voices)) {
-		snd_printk ("cannot set number of voices to 32.\n");
+	if (snd_wavefront_cmd(dev, WFC_SET_NVOICES, NULL, voices)) {
+		snd_printk("cannot set number of voices to 32.\n");
 		goto gone_bad;
 	}
 
-
 	return 0;
 
  gone_bad:
 	/* reset that sucker so that it doesn't bother us. */
 
-	outb (0x0, dev->control_port);
+	outb(0x0, dev->control_port);
 	dev->interrupts_are_midi = 0;
 	return 1;
 }
 
 int __devinit
 snd_wavefront_start (snd_wavefront_t *dev)
-
 {
 	int samples_are_from_rom;
 
@@ -2153,38 +2071,35 @@ snd_wavefront_start (snd_wavefront_t *de
 		samples_are_from_rom = 0;
 	}
 
-	if (dev->israw || fx_raw) {
-		if (wavefront_do_reset (dev)) {
+	if (dev->israw || fx_raw)
+		if (wavefront_do_reset(dev))
 			return -1;
-		}
-	}
+
 	/* Check for FX device, present only on Tropez+ */
 
-	dev->has_fx = (snd_wavefront_fx_detect (dev) == 0);
+	dev->has_fx = (snd_wavefront_fx_detect(dev) == 0);
 
-	if (dev->has_fx && fx_raw) {
-		snd_wavefront_fx_start (dev);
-	}
+	if (dev->has_fx && fx_raw)
+		snd_wavefront_fx_start(dev);
 
-	wavefront_get_sample_status (dev, samples_are_from_rom);
-	wavefront_get_program_status (dev);
-	wavefront_get_patch_status (dev);
+	wavefront_get_sample_status(dev, samples_are_from_rom);
+	wavefront_get_program_status(dev);
+	wavefront_get_patch_status(dev);
 
 	/* Start normal operation: unreset, master interrupt enabled, no mute
 	*/
 
-	outb (0x80|0x40|0x20, dev->control_port); 
+	outb(0x80|0x40|0x20, dev->control_port);
 
-	return (0);
+	return 0;
 }
 
 int __devinit
 snd_wavefront_detect (snd_wavefront_card_t *card)
-
 {
-	unsigned char   rbuf[4], wbuf[4];
+	unsigned char rbuf[4], wbuf[4];
 	snd_wavefront_t *dev = &card->wavefront;
-	
+
 	/* returns zero if a WaveFront card is successfully detected.
 	   negative otherwise.
 	*/
@@ -2196,38 +2111,33 @@ snd_wavefront_detect (snd_wavefront_card
 	dev->irq_cnt = 0;
 	dev->rom_samples_rdonly = 1;
 
-	if (snd_wavefront_cmd (dev, WFC_FIRMWARE_VERSION, rbuf, wbuf) == 0) {
-
+	if (snd_wavefront_cmd(dev, WFC_FIRMWARE_VERSION, rbuf, wbuf) == 0) {
 		dev->fw_version[0] = rbuf[0];
 		dev->fw_version[1] = rbuf[1];
 
-		snd_printk ("firmware %d.%d already loaded.\n",
+		snd_printk("firmware %d.%d already loaded.\n",
 			    rbuf[0], rbuf[1]);
 
 		/* check that a command actually works */
       
-		if (snd_wavefront_cmd (dev, WFC_HARDWARE_VERSION,
+		if (snd_wavefront_cmd(dev, WFC_HARDWARE_VERSION,
 				       rbuf, wbuf) == 0) {
 			dev->hw_version[0] = rbuf[0];
 			dev->hw_version[1] = rbuf[1];
 		} else {
-			snd_printk ("not raw, but no "
-				    "hardware version!\n");
+			snd_printk("not raw, but no hardware version!\n");
 			return -1;
 		}
 
 		if (!wf_raw) {
 			return 0;
 		} else {
-			snd_printk ("reloading firmware as you requested.\n");
+			snd_printk("reloading firmware as you requested.\n");
 			dev->israw = 1;
 		}
-
 	} else {
-
 		dev->israw = 1;
-		snd_printk ("no response to firmware probe, assume raw.\n");
-
+		snd_printk("no response to firmware probe, assume raw.\n");
 	}
 
 	return 0;
