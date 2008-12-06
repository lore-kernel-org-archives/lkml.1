Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYLFVPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYLFVPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 16:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYLFVOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 16:14:53 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:52783 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbYLFVOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 16:14:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=t5AbvisyWRbTzdNMqzM2MGXBCUhivPGyeVD49n62OrZoz2q2MYxDKSsMsfMBUWuwnt
         E2kTyKp65HTmvhT8Z4LC7yGGjzRWLKS/NvAxVxMRRAMf9LQ/txISz+4ZrM4vx4AfuF+x
         YVix4IjCl0bhctoquleC/TF3NSuC0/WaL/v0w=
Message-ID: <727e50150812061314w5c80e32ageca9c7eddc2e7aa9@mail.gmail.com>
Date: Sat, 6 Dec 2008 13:14:50 -0800
From: "Aaron Cohen" <aaron@assonance.org>
To: Geralt <usr.gentoo@googlemail.com>
Subject: Re: Shebang - why are parameters not splitted on whitespace?
Cc: Valdis.Kletnieks@vt.edu,
       "=?ISO-8859-1?Q?Am=E9rico_Wang?=" <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <fbdd0e50812060402q6aaaed6q6bb345c50ed68b07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <fbdd0e50812030714md7dd899xeb8940798632b08b@mail.gmail.com>
	 <2375c9f90812030756r5b8840e1u3980ddca8df27a6b@mail.gmail.com>
	 <fbdd0e50812030929q65d2e805y49094dd67209be7e@mail.gmail.com>
	 <fbdd0e50812030929s2d573981k46757c1b706f4cd5@mail.gmail.com>
	 <2375c9f90812051704oa80cafeif17909e332178d6e@mail.gmail.com>
	 <10860.1228542083@turing-police.cc.vt.edu>
	 <fbdd0e50812060402q6aaaed6q6bb345c50ed68b07@mail.gmail.com>
X-Google-Sender-Auth: 2647f99fb39ea74e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You should read this thread:
http://unix.derkeiler.com/Mailing-Lists/FreeBSD/arch/2005-02/0039.html

The shebang processing needs to somehow magically split up the first
line into the file into "some number of arguments for the interpreter"
"some number of arguments for the script being run", and "the script
being run."

The first two are the big difficulty, how should the kernel know which
arguments are meant for the interpreter and which are meant for the
script?

In the article I referenced, current Linux behavior seems to conform
to at least the majority of other OSes do, and I believe freeBSD
actually moved from trying to split the arguments up into something
similar (though I couldn't swear to it).

--Aaron

On Sat, Dec 6, 2008 at 4:02 AM, Geralt <usr.gentoo@googlemail.com> wrote:
> On Sat, Dec 6, 2008 at 6:41 AM,  <Valdis.Kletnieks@vt.edu> wrote:
>> On Sat, 06 Dec 2008 01:04:52 GMT, Américo Wang said:
>>> On Wed, Dec 3, 2008 at 5:29 PM, Geralt <usr.gentoo@googlemail.com> wrote:
>>> > Hello,
>>> >
>>> > I should have anticipated this objection :-). I'm aware that this is
>>> > not consistent among Unix operating systems (you can find more about
>>> > it here [1]), but I was specifically refering to linux in this case
>>> > and why it handles the shebang arguments as one big string and not as
>>> > single arguments for the application.
>>>
>>> I can't think out any strong reasons, maybe only becasue Linux developers
>>> prefer that approach.
>>
>> And of course, "whitespace" is a somewhat fungible concept.  'man bash'
>> and read about $IFS.
>>
> So you're saying that you can't do that because you don't know where
> to split the parameters, right? But would it be that bad to state a
> rule what "whitespace" is in the shebang line?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
