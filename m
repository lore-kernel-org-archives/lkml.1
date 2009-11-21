Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbZKUSED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbZKUSED (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 13:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbZKUSEC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 13:04:02 -0500
Received: from de01.mail.all-tld.net ([195.140.232.8]:55407 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582AbZKUSEA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 13:04:00 -0500
Date: Sat, 21 Nov 2009 19:03:54 +0100
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH 13/15] Do not fallback to default_llseek() when
 readdir() uses BKL
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de>
	<1258735245-25826-14-git-send-email-jblunck@suse.de>
In-Reply-To: <1258735245-25826-14-git-send-email-jblunck@suse.de> (from
	jblunck@suse.de on Fri Nov 20 17:40:43 2009)
X-Mailer: Balsa 2.3.21
Message-Id: <1258826634l.13034l.0l@oscar.alarsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-11-20 17:40:43, Jan Blunck wrote:
> Do not use the fallback default_llseek() if the readdir operation of  
> the
> filesystem still uses the big kernel lock. Since llseek() modifies
> file->f_pos of the directory directly it may need locking to not  
> confuse
> readdir which usually uses file->f_pos directly as well. Since the  
> special
> characteristics of the BKL (unlocked on schedule) are not necessary  
> in this
> case, the inode mutex can be used for locking as provided by
> generic_file_llseek(). This is only possible since all filesystems,  
> except
> reiserfs, either use a directory as a flat file or with disk address
> offsets. Reiserfs on the other hand uses a 32bit hash off the  
> filename as
> the offset so generic_file_llseek() can get used as well since the  
> hash is
> always smaller than sb->s_maxbytes (= (512 << 32) - blocksize).
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> ---

wrt fs/qnx4:
Acked-by: Anders Larsen <al@alarsen.net>
