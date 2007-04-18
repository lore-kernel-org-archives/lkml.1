Return-Path: <linux-kernel-owner+w=401wt.eu-S2992477AbXDRNje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992477AbXDRNje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 09:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992481AbXDRNjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 09:39:33 -0400
Received: from smtpauth05.prod.mesa1.secureserver.net ([64.202.165.99]:56712
	"HELO smtpauth05.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992477AbXDRNjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 09:39:32 -0400
Message-ID: <46261F92.2080607@seclark.us>
Date: Wed, 18 Apr 2007 09:39:30 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tejun Heo <htejun@gmail.com>, 7eggert@gmx.de,
       Chuck Ebbert <cebbert@redhat.com>, emisca <emisca.ml@gmail.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <88SeR-5Sf-15@gated-at.bofh.it>	<88Sov-662-3@gated-at.bofh.it>	<88SHV-6uL-29@gated-at.bofh.it>	<8agVk-3wc-81@gated-at.bofh.it>	<8b3IR-4mE-25@gated-at.bofh.it>	<8b3SA-4z3-5@gated-at.bofh.it>	<8b42g-51N-15@gated-at.bofh.it>	<8bbdm-7iS-27@gated-at.bofh.it>	<E1He8dA-0000mw-LI@be1.lrz>	<46260981.1040109@gmail.com>	<20070418132904.3322ba5f@the-village.bc.nu>	<46261337.3010406@gmail.com> <20070418140346.636879a1@the-village.bc.nu>
In-Reply-To: <20070418140346.636879a1@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>>Thought about that and querying power state before doing shutdown 
>>sequence but things get somewhat ugly because shutdown sequence is 
>>driven from sd->shutdown().  We'll have to snoop both sync and shutdown 
>>commands and check whether the system is shutting down.  Also, I felt 
>>very uneasy about faking successful completion to SYNCHRONIZE_CACHE.
>>    
>>
>
>If you see a synchronize cache succeed and you then see the drive
>shutdown succeed then you know that a sync cache can be faked as ok
>safely. Any other command in between or after and it doesn't get faked
>
>This seems pretty easy to deal with at command issue.
>
>  
>
>>I dunno.  It's already too late for 2.6.21.  I was hoping we could get 
>>distros to update shutdown utilities in not-too-distant future but I 
>>have no experience with that.  Is that just a wishful thinking?
>>    
>>
>
>Probably not, but it will take a year or so and throughout this time
>period everyone with the wrong combination of shutdown and kernel (which
>will be a lot of people who compile their own kernels) are going to have
>problems caused by what is a very obscure piece of libata internal
>behaviour they'll never even know about.
>
>  
>
So this is the pop I hear on my new laptop that is using 
libata=combined_mode
 when I shut my system down. I didn't get the pop with the same disk 
drive in an older
 laptop that was only ide. It sounds like a relay closing or opening, 
but is really my
drive head doing an emergency retract/park?

>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
>  
>


-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



