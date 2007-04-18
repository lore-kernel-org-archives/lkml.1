Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbXDRHlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbXDRHlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 03:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932933AbXDRHli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 03:41:38 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:47574 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S932929AbXDRHlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 03:41:37 -0400
Date: Wed, 18 Apr 2007 00:08:43 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Rob Meijer <capibara@xs4all.nl>
cc: Karl MacMillan <kmacmill@redhat.com>, James Morris <jmorris@namei.org>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
In-Reply-To: <19259.213.222.28.155.1176880873.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.63.0704180001160.2442@qynat.qvtvafvgr.pbz>
References: <20070416213350.GB4030@suse.de>    <Line.LNX.4.64.0704161846110.13905@d.namei>
    <1176846917.5946.79.camel@localhost.localdomain>
 <19259.213.222.28.155.1176880873.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

remember that the windows NT permission model is theoreticly superior to the 
Unix permission model.

however there are far more insecure windows boxes out there then Unix boxes 
(even if taken as a percentage of the installed base)

I don't think that anyone is claiming that AA is superior to SELinux

what people are claiming is that the model AA is proposing can improve security 
in some cases.

to use the example from this thread /etc/resolv.conf

if you have a webserver that wants to do a name lookup you can do one of two 
things

1. in AA configure the webserver to have ro access to /etc/resolv.conf

2. in SELinux tag /etc/resolv.conf, figure out every program on the sytem that 
accesses it, and then tag those programs with the right permissions.

SELinux is designed to be able to make the box safe against root, AA is designed 
to let the admin harden exposed apps without having to think about the other 
things on the system.

allow people to use each tool for the appropriate task.

David Lang

On Wed, 18 Apr 2007, Rob Meijer wrote:

> Date: Wed, 18 Apr 2007 09:21:13 +0200 (CEST)
> From: Rob Meijer <capibara@xs4all.nl>
> To: Karl MacMillan <kmacmill@redhat.com>
> Cc: James Morris <jmorris@namei.org>, John Johansen <jjohansen@suse.de>,
>     linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
>     linux-fsdevel@vger.kernel.org
> Subject: Re: AppArmor FAQ
> 
> On Tue, April 17, 2007 23:55, Karl MacMillan wrote:
>> On Mon, 2007-04-16 at 20:20 -0400, James Morris wrote:
>>> On Mon, 16 Apr 2007, John Johansen wrote:
>>>
>>>> Label-based security (exemplified by SELinux, and its predecessors in
>>>> MLS systems) attaches security policy to the data. As the data flows
>>>> through the system, the label sticks to the data, and so security
>>>> policy with respect to this data stays intact. This is a good approach
>>>> for ensuring secrecy, the kind of problem that intelligence agencies
>>> have.
>>>
>>> Labels are also a good approach for ensuring integrity, which is one of
>>> the most fundamental aspects of the security model implemented by
>>> SELinux.
>>>
>>> Some may infer otherwise from your document.
>>>
>>
>> Not only that, the implication that secrecy is only useful to
>> intelligence agencies is pretty funny. Personally, I think that
>> protecting the confidentiality of my data is important (and my bank and
>> health care providers protecting the data they have about me). Type
>> Enforcement was specifically designed to be able to address integrity
>> _and_ confidentiality in a way acceptable to commercial organizations.
>>
>> Karl
>
> Shouldn't that be _OR_, as I have always understood confidentialy
> models like BLP are by their very nature incompatible with integrity
> models like Biba. Given this incompatibity, I think the idea that
> BLP style use of lables (ss/* property and the likes) is only usefull
> to intelligence agencies may well be correct, while usage for integrity
> models like Biba and CW would be much broader than that.
>
> A path based 'least priviledge' (POLP) solution would I think on its own
> address neither integity nor confidentiality, and next to this would
> proof to be yet an other 'fat profile' administration hell.
>
> Having said that, I feel a path based solution could have great potential
> if it could be used in conjunction with the object capability model, that
> I would consider a simple and practical alternative integrity model that
> does not require lables in an MLS maner, and that extends on the POLP
> concept in a way that would be largely more practical.
> That is, using 'thin' path based profiles would become very practical if
> all further authority can be communicated using handles in the same way
> that an open file handle can be communicated.
>
> Rob
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
