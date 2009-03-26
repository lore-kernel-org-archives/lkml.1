Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbZCZTEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbZCZTEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 15:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759901AbZCZTDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 15:03:34 -0400
Received: from col0-omc2-s15.col0.hotmail.com ([65.55.34.89]:24812 "EHLO
	col0-omc2-s15.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760137AbZCZTDa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 15:03:30 -0400
Message-ID: <COL112-W81AF4A8C222B9941D8295FC8910@phx.gbl>
X-Originating-IP: [76.197.186.32]
From: Adam Turk <bofh1234@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: recommended programming practices for writing (was Linux 2.6.29)
Date: Thu, 26 Mar 2009 15:03:28 -0400
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 26 Mar 2009 19:03:28.0517 (UTC) FILETIME=[8C372350:01C9AE45]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have been reading the Linux 2.6.29 thread with interest.  I have written several (10 or so) C programs that write large amounts of data (between 1 and 2 GB file sizes are common).  A snippet of code looks like this:

if((fptr = fopen(outfilename,"w")) == NULL) {
  printf("File %s could not be created\n", outfilename);
}
else {
  fprintf(fptr,"%s\n",datablock);
  while(!writeouput(datablock,amount,tax)) {
    getnext(dtablock)
    fprintf(fptr,"%s\n",datablock);
  }
  fclose(fptr);
}

I learned C about 15 years ago and there was no mention of a fsync.  My C book doesn't mention fsync either.  Granted I have written only 25-30 applications in the last 15 years or so so I am not an expert C programmer. 

>From what Linus posted about git and checking the return from fclose I think I going to start doing that.  I also think I am going to start checking the return from fprintf and maybe write to a /tmp/file and then rename it.

So is there a C fsync that I should add before my fclose?
What is the proper way to write to files?

Is what I am thinking about doing something that would be good or is it just a lack of my understanding the problem?

Thanks,
Adam

_________________________________________________________________
Hotmail® is up to 70% faster. Now good news travels really fast.
http://windowslive.com/online/hotmail?ocid=TXT_TAGLM_WL_HM_70faster_032009