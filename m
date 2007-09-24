Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbXIXCn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbXIXCn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 22:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbXIXCnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 22:43:18 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:64162 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbXIXCnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 22:43:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=PXQIUzVbnn5+nUge7lMeJH7/tLR2fm7Rishy8TUjmUvPEcOvBHM0+CRgtJdXtWbu+Ax4ZwmSk3CpJHYQsRv76C5OZSCQTPCg/3xpa96Nt8feNN9XuRHMVmB1926nar6pjuC9MrtP7KhcurbMmxJPARL+5fIYYwO2qLjOfTroEe8=
Date: Mon, 24 Sep 2007 10:38:33 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: roel <12o3l@tiscali.nl>
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       marcel@holtmann.org, bluez-devel@lists.sourceforge.net,
       maxk@qualcomm.com
Subject: Re: [-mm Patch] net/bluetooth/hidp/core.c: Make hidp_setup_input()
	return int
Message-ID: <20070924023833.GA2442@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070923030105.GH2475@hacking> <46F6E502.9000101@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F6E502.9000101@tiscali.nl>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 12:13:22AM +0200, roel wrote:
>WANG Cong wrote:
>> This patch does the following things:
>> 
>> - Make hidp_setup_input() return int to indicate errors.
>> - Check its return value to handle errors.
>> 
>> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>> 
>> ---
>>  net/bluetooth/hidp/core.c |    7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>> 
>> Index: linux-2.6.23-rc6-mm1/net/bluetooth/hidp/core.c
>> ===================================================================
>> --- linux-2.6.23-rc6-mm1.orig/net/bluetooth/hidp/core.c
>> +++ linux-2.6.23-rc6-mm1/net/bluetooth/hidp/core.c
>> @@ -625,7 +625,7 @@ static struct device *hidp_get_device(st
>>  	return conn ? &conn->dev : NULL;
>>  }
>>  
>> -static inline void hidp_setup_input(struct hidp_session *session, struct hidp_connadd_req *req)
>> +static inline int hidp_setup_input(struct hidp_session *session, struct hidp_connadd_req *req)
>>  {
>>  	struct input_dev *input = session->input;
>>  	int i;
>> @@ -669,7 +669,7 @@ static inline void hidp_setup_input(stru
>>  
>>  	input->event = hidp_input_event;
>>  
>> -	input_register_device(input);
>> +	return input_register_device(input);
>>  }
>>  
>>  static int hidp_open(struct hid_device *hid)
>> @@ -823,7 +823,8 @@ int hidp_add_connection(struct hidp_conn
>>  	session->idle_to = req->idle_to;
>>  
>>  	if (session->input)
>> -		hidp_setup_input(session, req);
>> +		if ((err = (hidp_setup_input(session, req))))
>> +			goto failed;
>
>This is confusing, why not just do
>
>	if (session->input) {
>		err = hidp_setup_input(session, req);
>		if (err)
>			goto failed;
>	}

Yes, you are right. Thanks. I will resend this patch. ;)

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

