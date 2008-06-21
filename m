Return-Path: <linux-kernel-owner+w=401wt.eu-S1751816AbYFUPuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbYFUPuG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 11:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYFUPs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 11:48:56 -0400
Received: from web8703.mail.in.yahoo.com ([203.84.221.124]:45129 "HELO
	web8703.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753428AbYFUPsy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 11:48:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=mq9IyTwAcJ8eFv+KxpvrbUrQSbhRUrBqqMP7ZyxjGLH3ptcaU1yaKGPut43wzgR+jaypxR3ShQ7dZZHl7oqS9b1Sc+kNbhQGrm3tEBuxgbOR7JH5p9h5wbO6NMDksnKGbuPDc8H/CFVIRXLx+ZzGRzV7nh661eaELErUS0FQHGo=;
X-Mailer: YahooMailRC/975.45 YahooMailWebService/0.7.199
Date: Sat, 21 Jun 2008 21:18:46 +0530 (IST)
From: palani saravanan <busybeesaravanan0072003@yahoo.co.in>
Subject: Re: Behavior of lseek() on a fd opened with 'RDONLY' flag, when seeking goes beyond file size.
To: David Newall <davidn@davidnewall.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <807740.19494.qm@web8703.mail.in.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks David !

I have one more question, Does lseek() permits -ve value as offset, with SEEK_SET mode?
When I execute a simple c program to check that it doesn't return any error.

   errno = 0;
   rd_rc = lseek(rd_fd, -10, SEEK_SET);
returns rd_rc = -10 and errno remains 0.

>From the linux code, I am expecting the return value of -EINVAL,
when SEEK_SET is passed with negative offset (generic_file_llseek).
 http://lxr.linux.no/linux/fs/read_write.c#L34 
What is the expected behavior as per posix and linux?

Thanks,
Saravanan
----- Original Message ----
From: David Newall <davidn@davidnewall.com>
To: palani saravanan <busybeesaravanan0072003@yahoo.co.in>
Cc: linux-kernel@vger.kernel.org
Sent: Tuesday, 17 June, 2008 8:00:09 PM
Subject: Re: Behavior of lseek() on a fd opened with 'RDONLY' flag, when seeking goes beyond file size.

palani saravanan wrote:
>    In linux, I see that it just goes beyond the file size and returns the resulting offset.
>    For example, 'rc = lseek(fd, 4L, SEEK_END);' on a file which has 5 byte contents,
>    it returns rc as 9.
>  

Sounds right.  It's documented that way, too:

       "The lseek() function allows the file offset to be set beyond the
end of  the  file  (but  this
       does  not  change  the  size of the file)."
           -- man 2 lseek
>    I expect that it would return size of the file, i.e.) 5.
>  

Only if you pass (0,SEEK_END).

>    Does the file pointer internally really points to the new location.?
>  

So the documentation promises.



      Download prohibited? No problem. CHAT from any browser, without download. Go to http://in.messenger.yahoo.com/webmessengerpromo.php/
