Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbXCTGZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbXCTGZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 02:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbXCTGZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 02:25:19 -0400
Received: from relay4.usu.ru ([194.226.235.39]:49162 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515AbXCTGZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 02:25:16 -0400
Message-ID: <45FF7E5B.3070602@ums.usu.ru>
Date: Tue, 20 Mar 2007 11:25:31 +0500
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
References: <45FD6EF5.1030706@ums.usu.ru> <87hcsius7b.fsf@duaron.myhome.or.jp>	<45FDFC69.6020605@ums.usu.ru> <87d535vqrz.fsf@duaron.myhome.or.jp>	<45FE13B9.8000203@ums.usu.ru> <87vegxdc8i.fsf@duaron.myhome.or.jp>	<45FE2483.4060706@ums.usu.ru> <878xdtux71.fsf@duaron.myhome.or.jp>	<45FEA669.1060301@ums.usu.ru> <871wjlp2l0.fsf@duaron.myhome.or.jp>
In-Reply-To: <871wjlp2l0.fsf@duaron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> "Alexander E. Patrakov" <patrakov@ums.usu.ru> writes:
> 
>> But, anyway, this is a separate issue that my patch doesn't attempt to 
>> correct. The conclusion so far is that we disagree, and that there are 
>> situations where using utf8 iocharset is the least of all evils, so the 
>> warning is not justified enough. Reproducible testcase:
> 
> Again, I don't care about read at all. And why don't you use "utf8"
> option, instead of "iocharset=utf8". "iocharset=utf8" is warned until
> it is fixed. The "utf8" also doesn't work correctly in some case though.

Would it be OK for you if I add the mount-time check for iocharset=utf8 to 
the fat filesystem and silently replace this with the "utf8" option, instead 
of overly actively warning the users? This way, the sysfs option and the 
nls_base.iocharset module parameter will still work as I want.

>>> I'm talking about two filesystems on a system here, not two encoding
>>> on one filesystem.
>> I am also talking about this. Mounting two filesystems with different 
>> iocharsets is insane, because this will result in one of the following outcomes:
>>
>> 1) "ls" will show wrong characters in filenames on one of the filesystems
>> 2) one of the two filesystems will contain wrong on-disk data for filenames, 
>> that, when misinterpreted by mounting with wrong iocharset, results in 
>> seemingly-correct output, but is misunderstood by the properly set up 
>> reference implementation (that's what is likely to happen with jfs in your 
>> example).
> 
> Because you didn't change the locale. And it is your policy, right?

Yes. This is because I have some files with non-ASCII names in my home 
directory. Changing the locale would make these filenames look wrong until I 
change it back.

-- 
Alexander E. Patrakov
