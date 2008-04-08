Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYDHVao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYDHVao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYDHVag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:30:36 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:34563 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYDHVag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:30:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=IUFC1kwVOB9BLIgYUo0aSCH2ZMLLuV4SmkVP37r8yAPrbLXkR3aeAfa1z7hPMXiSo4o6nZdQIJ/PUElI/Ixd3hgJTph6P5LEpDqjK+QfV1UtzzkWke2VZpJGVv7rPZzIAKY9DJ3Sx/YDY9V95RdUDbzwsc9REV4qo4RNGh0eGaY=
Message-ID: <2f11576a0804081430q4283e6f2t1e573a8362ebecc@mail.gmail.com>
Date: Wed, 9 Apr 2008 06:30:32 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Jack Harvard" <jack.harvard@googlemail.com>
Subject: Re: lmbench memory bandwidth benchmark
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <a72f6a3c0804081045r6eb4c6awdae2f3be0ccc416e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a72f6a3c0804081045r6eb4c6awdae2f3be0ccc416e@mail.gmail.com>
X-Google-Sender-Auth: cd87d094d6670028
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hi, can someone help explain how bw_mem function works in lmbench? the
>  source code doesn't seem very user friendly, the papers are too vague
>  to help understand the code. an example for "bw_mem 512 frd" would be
>  very helpful.

maybe, "gcc -E" can help you.

e.g.
 $ gcc -E bw_mem.c

got below.

frd(iter_t iterations, void *cookie)
{
 state_t *state = (state_t *) cookie;
 register int sum = 0;
 register int *lastone = state->lastone;

 while (iterations-- > 0) {
     register int *p = state->buf;
     while (p <= lastone) {
  sum +=

  p[0]+ p[1]+ p[2]+ p[3]+ p[4]+ p[5]+ p[6]+
  p[7]+ p[8]+ p[9]+ p[10]+ p[11]+ p[12]+
  p[13]+ p[14]+ p[15]+ p[16]+ p[17]+ p[18]+
  p[19]+ p[20]+ p[21]+ p[22]+ p[23]+ p[24]+
  p[25]+ p[26]+ p[27]+ p[28]+ p[29]+ p[30]+
  p[31]+ p[32]+ p[33]+ p[34]+ p[35]+ p[36]+
  p[37]+ p[38]+ p[39]+ p[40]+ p[41]+ p[42]+
  p[43]+ p[44]+ p[45]+ p[46]+ p[47]+ p[48]+
  p[49]+ p[50]+ p[51]+ p[52]+ p[53]+ p[54]+
  p[55]+ p[56]+ p[57]+ p[58]+ p[59]+ p[60]+
  p[61]+ p[62]+ p[63]+ p[64]+ p[65]+ p[66]+
  p[67]+ p[68]+ p[69]+ p[70]+ p[71]+ p[72]+
  p[73]+ p[74]+ p[75]+ p[76]+ p[77]+ p[78]+
  p[79]+ p[80]+ p[81]+ p[82]+ p[83]+ p[84]+
  p[85]+ p[86]+ p[87]+ p[88]+ p[89]+ p[90]+
  p[91]+ p[92]+ p[93]+ p[94]+ p[95]+ p[96]+
  p[97]+ p[98]+ p[99]+ p[100]+ p[101]+ p[102]+
  p[103]+ p[104]+ p[105]+ p[106]+ p[107]+
  p[108]+ p[109]+ p[110]+ p[111]+ p[112]+
  p[113]+ p[114]+ p[115]+ p[116]+ p[117]+
  p[118]+ p[119]+ p[120]+ p[121]+ p[122]+
  p[123]+ p[124]+ p[125]+ p[126]+ p[127];
  p += 128;
     }
 }
 use_int(sum);
}
