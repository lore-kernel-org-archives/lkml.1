Return-Path: <linux-kernel-owner+w=401wt.eu-S966768AbZLHW0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966768AbZLHW0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966683AbZLHW0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:26:22 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:54939 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966651AbZLHW0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:26:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=GGWpIoUD4aknvW7W9mUHJ+eXCEul0jwlMnMpA2s4XLCGkgnneQKYGdEy/0DlNicPOU
         LnUTxUhmcYzLpk2TqE4feMGAmDTO40A0zE515hKzZ5suQGN67iAtQLyfW/gBskg3Hqgy
         84OIS1a9VWJZsstF5M/LwDC9+Hx1+idLgIho4=
Message-ID: <4B1ED291.60902@gmail.com>
Date: Tue, 08 Dec 2009 23:26:25 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091122 SUSE/3.0.0-9.1 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com,
       achiang@hp.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com
Subject: Re: + hpsa-use-msleep-instead-of-schedule_timeout.patch added to
 -mm tree
References: <200912082204.nB8M48oL027313@imap1.linux-foundation.org> <4B1ED241.4090803@gmail.com>
In-Reply-To: <4B1ED241.4090803@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2009 11:25 PM, Jiri Slaby wrote:
>> @@ -3302,7 +3302,8 @@ static int __devinit hpsa_init_one(struc
>>  
>>  		/* Some devices (notably the HP Smart Array 5i Controller)
>>  		   need a little pause here */
>> -		schedule_timeout_uninterruptible(HPSA_POST_RESET_PAUSE);
>> +		set_current_state(TASK_UNINTERRUPTIBLE);
>> +		msleep(HPSA_POST_RESET_PAUSE_MSECS);
> 
> Hmm, setting the state is superfluous, as msleep does the job itself.

(FWIW addressed by Andrew already.)

-- 
js
