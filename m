Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbYKWWbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbYKWWbv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 17:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbYKWWbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 17:31:43 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:52515 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbYKWWbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 17:31:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=vb3sm9qZwAr5x2J7z2F9ImzAcNS9RsH228s+nTq+sJPpce4EgyMhwhOB2ZF4YPhA2v
         nq+viyCP5gVrmo8xkzkbHxgL7NN9OBjYt1fjxlBpd1iarNfvnWv9uEElpcORGHlfvL1J
         PVbKLwirCWw/+YpAIymK04in0PUheBiPMJnQo=
Message-ID: <7c86c4470811231431nff93661xbfb04b6b6f81abfe@mail.gmail.com>
Date: Sun, 23 Nov 2008 23:31:40 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Markus Metzger" <markus.t.metzger@googlemail.com>
Subject: Re: debugctl msr
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1227347491.6146.13.camel@raistlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <1227133570.6104.10.camel@raistlin>
	 <7c86c4470811201319x2eb93d41vbdd8ce480a797fab@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F115BC@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811210538i5e6958e1p2c31effa762f5914@mail.gmail.com>
	 <7c86c4470811210727o13006d5bk5bcbacb791e51b1c@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F3B93D@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811210833l5c8005b4l675bc51df50affaa@mail.gmail.com>
	 <7c86c4470811211447p57b38ecy9520a9e5170d2ce1@mail.gmail.com>
	 <1227347491.6146.13.camel@raistlin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,

On Sat, Nov 22, 2008 at 10:51 AM, Markus Metzger
<markus.t.metzger@googlemail.com> wrote:
>
> ds_access() returns the pointer into the raw buffer at a given index.
> For index 0, this is the beginning of the buffer.

Ok, I missed that call.
>
>
> I plan to replace the various access functions with a single one that
> returns a const pointer to the configuration.
>
> Something like:
>
> struct ds_config {
>  size_t number_of_records;
>  size_t size_of_a_single_record;
>  void *base;
>  void *max;
>  void *index;
>  void *threshold;
> };
>
> const struct ds_config *ds_config_pebs(struct pebs_tracer *tracer);
> Would you be OK with such a change?
>
Looks good.
There are two calls on the critical path for perfmon : get_index and
get_threshold.
So we want to make sure it is as fast as possible.
