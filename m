Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbZFRP5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbZFRP5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbZFRP5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:57:43 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:25428 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbZFRP5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:57:43 -0400
Message-ID: <4A3A6328.90408@oracle.com>
Date: Thu, 18 Jun 2009 08:54:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Amerigo Wang <xiyou.wangcong@gmail.com>
CC: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       samr <sam@ravnborg.org>
Subject: Re: kbuild docs regression
References: <4A367744.2050207@oracle.com> <4A379AA6.9030508@gmail.com> <20090618094604.GC6133@cr0.nay.redhat.com>
In-Reply-To: <20090618094604.GC6133@cr0.nay.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4A3A63EA.0115:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang wrote:
> On Tue, Jun 16, 2009 at 03:14:14PM +0200, Jiri Slaby wrote:
>> On 06/15/2009 06:31 PM, Randy Dunlap wrote:
>>> make htmldocs
>>> without using "O=dir" now (as of 2.6.30-git8) fails with
>>>
>>>   DOCPROC Documentation/DocBook/deviceiobook.xml
>>>   DOCPROC Documentation/DocBook/device-drivers.xml
>>> exec /scripts/kernel-doc: No such file or directory
>>> exec /scripts/kernel-doc: No such file or directory
>>> make[1]: *** [Documentation/DocBook/deviceiobook.xml] Error 1
>>>
>>> (+ more)
>>>
>>> Using V=1 shows that SRCTREE is set but KBUILD_SRC is not set:
>> Hmm, thanks, actually it's set, but it's empty :(. Is it expected, or is
>> it a build-sys bug?
> 
> No, it is a bug of docproc. Patch below fixes it.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
> diff --git a/scripts/basic/docproc.c b/scripts/basic/docproc.c
> index 4c9523e..99ca7a6 100644
> --- a/scripts/basic/docproc.c
> +++ b/scripts/basic/docproc.c
> @@ -385,7 +385,7 @@ int main(int argc, char *argv[])
>  	if (!srctree)
>  		srctree = getcwd(NULL, 0);
>  	kernsrctree = getenv("KBUILD_SRC");
> -	if (!kernsrctree)
> +	if (!kernsrctree || !*kernsrctree)
>  		kernsrctree = srctree;
>  	if (argc != 3) {
>  		usage();


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
