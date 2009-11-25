Return-Path: <linux-kernel-owner+w=401wt.eu-S964893AbZKYWOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893AbZKYWOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 17:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935047AbZKYWOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 17:14:10 -0500
Received: from verein.lst.de ([213.95.11.210]:60685 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934818AbZKYWOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 17:14:09 -0500
Date: Wed, 25 Nov 2009 23:13:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Len Brown <lenb@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: regression: 2.6.32-rc8 shuts down after reaching critical temperature
Message-ID: <20091125221332.GA24173@lst.de>
References: <20091125102857.GA28310@lst.de> <alpine.LFD.2.00.0911251647000.3950@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911251647000.3950@localhost.localdomain>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 25, 2009 at 04:56:19PM -0500, Len Brown wrote:
> "thermal.nocrt=1" will disable the actual shutdown -- but you'll
> still get the warning -- which might be helpful.  "thermal.crt=105"
> would override all critical trip points to be 105, for example,
> but otherwise not change any behaviour.

Well, I suspect the warnings are there for a reason, e.g. with 2.6.32-rc
I also hear the fan regularly while I've almost never done before.  So I
guess the reason for it is that throtteling might have problems.

> > I've done some attempts at bisecting it, but for most of the 2.6.32-rc
> > series the system crashes during boot in ACPI code with a backtrace
> > longer than the screen can display.
> 
> Hmm, I don't have a T500, but I've not seen such crashes during -rc.
> Please send along your .config

Attached.

> Do you still get them when disabling the thinkpad-acpi driver?

I'll try.  This is my main work machine (and I'm travelling right now),
so any sort of bisection and testing will take a while..

> Probably the most interesting place to bisect is drivers/acpi/ec.c
> 
> If you can send along the dmesg from the recent failing kernel,

That is failing to boot, or the 2.6.32-rc8 kernel?  No chance to capture
the dmesg of the one failing to boot unfortunately..

> plus the output from "grep . /proc/acpi/thermal_zone/*/*"
> that may be helpful.

brick:~# grep . /proc/acpi/thermal_zone/*/*
/proc/acpi/thermal_zone/THM0/cooling_mode:<setting not supported>
/proc/acpi/thermal_zone/THM0/polling_frequency:<polling disabled>
/proc/acpi/thermal_zone/THM0/state:state:                   ok
/proc/acpi/thermal_zone/THM0/temperature:temperature:             46 C
/proc/acpi/thermal_zone/THM0/trip_points:critical (S5):           127 C
/proc/acpi/thermal_zone/THM1/cooling_mode:<setting not supported>
/proc/acpi/thermal_zone/THM1/polling_frequency:<polling disabled>
/proc/acpi/thermal_zone/THM1/state:state:                   ok
/proc/acpi/thermal_zone/THM1/temperature:temperature:             49 C
/proc/acpi/thermal_zone/THM1/trip_points:critical (S5):           100 C
/proc/acpi/thermal_zone/THM1/trip_points:passive:                 96 C:
tc1=5 tc2=4 tsp=600 devices=CPU0 CPU1 

--XsQoSWH+UP9D9v3l
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWQW4/hEACARfgEAYXOf/+j////C//9/gYCB8AAHvvffAA8vd5dkARyT6dnOY
AAQ1rBESl1nFRpUqgkbKkC2UNKFYhkxBEDoW7N07ucBVpl777722py6vveGphAmmQGkwQRAm
j1Eepp6hkaemmoAaDTQICAIQp6QQgGgwA0QYQAGqfpExT0KbFHtUMgAAaNqBp6TaRoMhoCTS
iJoJiBU0/TKn4qAAGgGg000eoNAEkgk0T0YkGI9TUbRpoxqEGj0n6p6mjZCMTCRCEAIIBU8q
bSehADQANANADn/76lk3bWGEFgbrVF+LWCxSGfq5Y4GKoP+BB+m4rZ9F+XAGmL8u4kkvf/qm
ib098UU+lJ2TmOYslSLAVGAoeuPbOUVRVUSRZFUVSKCLBFUwlVCoVBRVJbYI9rKMqSquKFSS
KsWKO1wmGLaFWKW2FSqlZWCxahWDaFW0lW0lVh3oEKJAFg4tVBtogKLIqVoVlEFWaMkvhZlM
W1A2tRgqrhba1kUHWhVSYS0sFNcUqYRQUFhWSophhVarFWVCxskFAmjJHEBcRRxQr633znAn
tZsi4GIIoxEUVGIMRVMraIkiICo+9ojhCisRVRo7OJiyooqu2tJhho1ODR1sCgLIpSlBa1Fj
m4xYosrKiijEY1mLcVoqqIi8MNutDKqxxQaUKUKVoxnOk/eCWijJoyz4/LReq0+b5s3O9CQC
KhiWP+T+BjqZ0jj/a6v6f923/XC01jzOZPq0S21EwEsPQmZDVhoUcyf6SFIH6O1RGIiyjYFP
nr/uavbHf++rimaLoPVwmhUvI1jZ/SoQS1VUNfNiwOFlPVl4Yw/p9ZwvMblEl+1Gg/p85Xvx
lXO75qFf6Uv+iwvuWVg+lM5qIS01qvx+G0tRCMeE1tGRU+JUgYxbzFCTiPxt3eGlJ+8xOKFt
S+cNUI7bdOhj+xv62HvhnJeaTk1yN1RbL+vMpOEOJ3rR0Ppx1G9vMX9R14Vcnt2k2vbYdpwd
ETPe0dqoh3ciHOq8PTps7R8LOG78t4fc6eyfvRmjcuaxhzBM9rBeSuw0wUrMkOF3PWziR8ds
ajQ9jRGrrF3T5vJyWo98HIkHnFLvLt3z4yzd4w51BpmI6YLEsQWpFnBMbLOZg3Cw12071dm+
mv6jGnjrC+NYG2Oyxo7et27Z2NlDSZzo12M655lg+w21RlxMv6dMMuTNddGpZvu3pd3yXRe8
MBjpXSrXb2PxaLRlibthk46Z3GJeVT2bsM4vfZ5bBoSpyKK3k45BHTGGYpJ7ukNbrXSgLeUm
pxWl3O7nXyvXjjzvu6QjhSDrYEpZFeMqN4zR7+KGuNKNbpCmtIO10yTW3o1+WFMeMIyynPS1
oJb8W8dIQdVuAEs11+667Nbjj5flXpzaQSARn636N+LOok2YLYJAIjalrsfNDG51kskdUe10
blHN97KWhtS1oBCFtt67GWSepqb/vf2C80/Z7KWb+unu98hOv9S8fHU7rjXj0QGgaTWq0EQV
YPSYLWgtX9k0xh9mK0itZsVFR8yWLFR7zAWiF9ilVkTBTKShW3RZNHORh+bt3UlrkOhIr8Qo
GGF6fYgaXPQobj71u1F9ZdjtbID3EfMaL+v9nWgj459MNs8e86nXX9Uc/r7m3Gj5X2QSSf9j
9VvMzuQixdvVY4H3uigxAAUukVQmSMbpBFgfKX4sb3uRk605VyGDI9W9rQtI+Q7xdTjsebbR
46ArovFGiiAR8XkQIsCgeGfhbG0neKXtzza1B9Lf4Uz8Uutm7I51UA+n31mt93832qNoEye6
y3x73o4A/D79C8C12pXhFz5pIJcitFATz5EpHRB2WRvrZh4vm8h2namOO8FwbxewIr4yTCNa
935cQT/yQToxBUnExCJgPzxmM8bNTepAriPKrfVHayyuXrhTYz8eokV5U1HktKj2wDIFyTBM
ZkQDDAFxBRH8/MBluWbTkPJI3HqOpErFBIXfottGu+V6IAz7ZeNvhc75L79/z69k7EbrtzUe
hZAiCeUksL6zDU4N+5LgS084Pln7dqf3nlbYUOvhLiTPuZo6VmH3Rt9NtHNkdZtbesvD2lVa
4BuDuzqScL8kuW+zWQstvTCB9MtST7IRKko232OrA13RNVgPuJCWLaUxu6mvBwtJ5e7F7lyK
aNXPFF18a2QjmtlJFZq3KE9TXBboo3Pk4W7ZCAxcEJO53qtJ4C89b5rgixlZRr2zR8dy+nVH
vrfO9s/iehCnWj3f0bXCzVbblX8cb8riN9ahvicXidF25aw522po0I0aaaROMxSvimRMRyw+
JWshqBpUnSebH/nRf67WoUucUTU53SiAjJmgJRv9B3TesqNF98xu6C34diEfXpq+rdTMZVsU
T+0xeGF+5c227zPR3aBWyOmXRPx+bT55Zk6jTMR6UmHFoSv0R+9lgWRBonDo/T6EF6JLpyNq
qbacgT53SzG+AwZ8VSMDGB0000qA1IrGqyRe8P1zIAZ+nczh1sRHffjVaHjLHRDA1xgkAt5J
rw6Z4g085DODd3xJZ9B51el8hjFq475qytAiGFYKVKyotEERiqO3QmvHj0TQcMLitl62nyqL
1S+CkbNMQw2W6Lnh9WeaOYi+ilh01mOeoFswC1aSkqGHqw/gWSX3fOOiS0JK2axezKhvQOJj
2XJWvAlaToMtBIyIqmYtMaoN1x6DRz2IShJSc6ezx6UOrw13GFninn3kKqoEZhzpIaM1MWBv
SosgdBDkIhI8oPlF8hZ+dSu99V9mcMM7Ys8Kb4jd69sB1ag/GXhxrsul7GuMvaywgt1RHChQ
fJSxolPhkhk7aOfrprymp5gqx0PXuEuL4FaQ5vBdxFTOwXV3jm16KFiD4uhQc0Qj1yQtFuxM
6i227Hm57uexkYKq057t9wVMKMGKhhxiTy2nWMx04XXIPZZIe/CnI3UNey/v8JFVIIsBSIjF
QVUWRiIooKMZEVFkWIrFBQRBEFWRZBEVVRjFVFVjBRGKjFWIxVVUEUUBURFILFSMjFEVjBVR
UZFgRBBIgioxgxUBUYqCCkWKsEGCixFGHwSkQYqqooijEUFFiKsYLFFgMFFjFkgskRRFEFRS
AKRYqMFERGCqiIoxGIIoxiiOaSyCyIqqrAGCLFgiKRFgqsURFijFYxRFYKooqDBYwUUWKCqs
RFgxIosAUirILCKxIqgqyIZh4MDuQNHteacF1KAw6frKPZrNcm8ghWJg5LJIz5CAbqEdiIUL
a52gyuiKRn7gazFzKVO8Um2pDXn6rR3dG5MvBAQPO0EsVDDXi1ZWhjZec5pDbta1QnTUa14B
TjVZzO/WL9uCJ+q+bGlzEU3l5q2rpIGUm6kI6uFva93pw2Zp3Mxwb9UJuo0T4x8EaZ2CTE78
uySDPzCRoNWIEiDW5TnMUc9L3fXvFnerBEnokwwRA2A39eNeVjdPeC0wTAZOsGk/OLHalpMC
hgcteHgWI0UeYE0lB22l3Xx9eAHSEB/TV25rcgn2zuwPBXcibiYAfr0sSsoN+UQN8i+mbeMw
v4NdosRoW8ODWBBe5N1k591kcoHl1rV/uQ7XmlqFxOPZpIc3iaawHNNY1isk0rpNBPrOornG
wyIAQC32YwJ0+cotX+4ScLgHFEHFrc0DS6wS1+agUEhJqoUu1iHGnspSxmZkxqgbNKmxu4Rt
9GUaGDmDRpsxBdvYcw3bVHfP7SV0HnXHlhoBrqBA5Edw2gCZvYWd4WhQlrgXaozgV/ODQz25
JYkdUsrBxria4HQV7eO3chUvwW13VbixqoICbBEIkoKj3Q4YaeLTY4ZB7aVw8KCrriIauq7D
vxblx2PDL3C0EBuDQqrtTs9CFxKsyIWC0oI8TXBLJYjy0F2jxzsYVK+3eRKWDaDyZpYNZiw9
peV0FNAGKYGOMmrptIqJWgkYL2woWrRRXHtI85C63W5a6sWJ74Mw80oMVoKEVWM5j4rv9GvN
K9Ha/5OYlpsGNrjLEmvtGj7gJJJakDMI9JplTppRBaPapIYSsAzIZ7CTAQQUTBQPsmGQe2F7
uo8ZCL7lQxtvPnFxe/zvxr16rjzfiA8gqMNmYLS4GwIxVW9BPNRlJ+wH+kDanaq4MEAsocMl
1vEMC0LLK5B9/I8bDV3NRyKXzX5H694hr7RF+2AD4owcqBIyZYNa6ICng7EavobXV9qPX52C
tvm4dMJahgIOHIxDQiwJMMAKwqErIQUgALAAUFJyakWBBYEhjNIYYLIQUkkLpQwhAFFkBYCI
CJIGyAkQxJeynLg2hEEyQEahs4baA6aC3G042qJnWRQBE37IYMHCmWcByN0tMshCpHSgMMCz
Ssr3E2DvCwFB7yW79c97WvrNRl60TJGh4uGJW4gIYcmRrnGcl4oay9VpwOmkQpK4d9RRTXs8
7mWvMx6TkjDDEplCrRApQNfhkrwOwDpcPD2hZMHlxXeor4VWoQtet8448vHfLJ5GECEuw0JA
C0lchbUwvQwLLixKKucNLdmVp+szIquGShDZQ+I89pBi+iYvaCmwsrIDsC5CAdHbyQOcjvrf
D/ZRcKNIaOaSTabZFMTmoVFeMHxN3rzmL2o4giCGQ2ZQEEv6b1sh7FWcWOFHXrcJMiQqqTdb
AuCgSpUabppW0cQrUEYAtSlQAPCRd6yGMXNr7z+N9AYfCu7GhEbpu0ZyF4jw9htvaKlHxKgj
Dy7i07s5EEKSewMaDcKqCAF51bzlYsv05IMxZdiJlwsiBQGB/HNKh821YSwxBawoU1N1CIIo
5wpZYI2HfvVX03DkEBdoeDDVjPaq0RLECgdirKCC7Kiv4n4B7p1r6x7qfG80Qpx4AWoUg6pz
xYW4XkOruaEbEEmVJW1CFpJ3KWmAMz7VvG2uXGtrCgJVStdShRGIJx9urEfaN7Zfs/i5Cnb3
74IOu2ajIqq6pwxREEtGvAZC6iCbuGyW04iNzctprBbfLXFihqd24p7DWuI76ZToMtlGKLqk
kG+aGIs0jZcIyz9ZuekZ+wpATAIJyqhd984Ew5gZanppIrehrmGUqO56e5+VxYOYCcbYcLWq
oxKcrnCgcsVB1UOCgwMrX1C0vCVChUUolxFI0zmFpqCiMOPlQL2ImaYEt2XSdcnu6DPLfZ0j
DbeKbbzIiGRGbkeGksff6icJd49GBnlnB5apdxrpZhUy/NQEF45+Tc+qAIH7RD00+sRytvZh
nLSYXQ7u12zroFbL8CaagmbUr6unZYaduMErMMWXFHtXbk7MMsUWwhwrTlV5VwimSSRLYxfT
VnYgmdCR8Trd0DcOtIFiLFgqoJB35ISSSWTEAZUN+cYUNtKOKWc2UCGMgBFEpVFUglkc8Qa0
L3kAyJWTCYQZizIX4SXY7Jxe0lBd5UXpjYwuXZOx98i5gb54nKoyedop0HAFts19d8/FB6sv
rHlCqPfENzP3XcdkafJiqGPtCUNIiBe/uxiR6ogbRu0WCwfWxwUvjRjG0yBbHxpm8WGgoKeu
fPzHBfVj5I8vWxQ0pI6YoYVWPbTRMcD14cu3jtxoyEkkm2Kb2BqIFRfpprGbySup40KbDGQn
ueJ5KRrdgPAFfGyAYVUE8aC1AMn3S11yiNkc8ZZIj5wZ+h8b64IXVkd1rtbnpZkGqX1KNfd+
nfPXuFLXRfcvdIPVpRlCIVVVZmBAJQgoSxT5/G/HPTc4y0/G0YeGz6GH0+IWLc5V7Ri++Ka8
CyEhl2MBi9mCsmJBm2F/WKXJM6Z4UNcsPDSLFzSMkSwhhTEKHO9LZz6d/aieO70ptaZnSqxN
veYJKZZyEuCb2ViLWOUOYlU1HaE6Jsbnavll+YtkgqQhv4nWTHfi12EnaMmd18owOUdVdt95
syz57BFx5ovAgTLL53s17VpCSk7trNBy+qUPeIzcLhtnqh9fp4z0cVySOOcTV2W533iW5XVq
KoeWLEZlDppV16Y0hx3YiTxezXXCbY4092/ai3rtgNnr4bZKSwHFiTszOLXpMJ2js1UFK5AY
TwqrjHN7sbtfK712wyWRHo5ELpmTzRcjuwvnmr9gysFky9St5raQKaKCpxPvAGrEZj/iJg06
ncqex5sHx7wPjdt8e1YVwcw62sMgJMQlEm6RY+WCBhqS7lQ+audnRPCELrJKnY2ZoD0rBIoZ
GV5BQopDEI2lCrcEDptqq4qVur+vOKUEgtsBvMRootOXcLHDCaL6NTrRrbvnfmoCngOG3Ra7
Azc7nKqFXvZgxccswaaMPteGWp6vXKzBFomqja/KPdpLnvFiyXlpITaSjKo7KA+nhtMbOres
n0v92RTSWQOHzHg5JRvxaDXtvEZo9SyIRKVHMi6djKAXaIAlu5waVu1csoAxlN3qF2cD3P3c
0RtwHgoDQPaAyAGtDWPRkO72oGkIz5IFSU6mGyHikwJroWTwd+4Sl5YGm59Bh26GdWt8mb45
T4dacc77sZ2ap+BoV7XCX4hHhe15C7+mBmxPty/bP01gSK0uTJNM8WxNkcNBZok4YZCWIoye
ehWUJCM6kmS8UhNCnaJ1KZ3vmF9ps/1aODIPyfRWre95lKL3AxBjmLobgKgqKIBQLxXjWFvS
gfdWFKRzjeKEUBju4bxYQ+txsLocrBAZVayOQGCUAlMw/baqFEJUY2oOcucjZhnjEk1rjbKX
I+pGofGBa52CXDvoiQ3nXjBe7GY9aq+l1fmNt9s4LYnJbRkxQ7KIMd8F2kQyHOaLMKkAaguE
TdarwznSr+70K4T0jTjJ43hZYfGYEMBGNKRWw9XbchdZ6yu0RlMz1Ywi2/C5LGCtWLoiwQgt
GZd00ZMbBQ4LYNurZxC16sokEu2i5tXc1SoJ7w0B8MqB032rFDJvpJaDBkrVQxnpQPSU5sUW
cg7Dg+0jY5rEsDvvKcjUG4ZPdJZLCgQQ02iWM339Qk437a4SLQgqLq+f/PCnm6ISgmz8O1Vz
7VSVsNPuuqfSd/KTaapiQoGLCXELsdsb3zaLWC/bu1e/eADioFieCZ3PCO/NedwO2QGCtTYL
1HAyLA9LKEpXxzE9scxlfLRD7tLIQzdNXeTppPlwizglilpIx7YieMaPDT695rUgId3CMmRk
1FeJ0MG1GtCOIMzTNn4EK2+ns93p65bC/Mw/sH9HfYfmb4LxrWsrvaIPVMn3agS+XYZiKPhi
KabnzvAeWqzyHvuaVQ5iPm9/vfb6MXrm312+GvsxZVg4Qhb204ISNWK978XzoUu3mrRxbUt0
LljWe0Kwfo/Sep0Svyum9YpldsPqrD5NhUUCbpnZk9vnLT3NQXC+GiB3JTXMIBbv0VYs2U2S
j5Oa0HaUFNCSw0BBIA39LMYxiESCPfGq0cYzVgmSOgYNBZ2GT9bfQJ4tTV1SdEwnTN0y3DTg
0zaZwu5xGZp6otUAYNghswBmTgxg9hdVVmTC6vk+MZfWeSZVytx86OCPrjqCaqQYNCY8zeQA
DMQh4EloRG58VNkvXn0uva+tN2XS5KFAFIQakAbtPNfFJWix3XzcLvgukcMG2xtdqrX2jfmA
829O94dgUvjj7SDexQMeCLGxCwBXR7VIC2kdbZeApFSLr8cqj1hQSAOFZuCI3243iNefMRHW
WTcRHw3iQKFO8KPhDz330fDrQXTl2Xn56ZxpoXRavLpkK9/SySs0iMkGZBHutXVpMMETKl5e
cciECHLsamJkGTkDBbQdB8YlF+YJezpiQVDUCzaKJIEiXh+jxltIgtW+Wdh1AZ5wT9OG/kYk
YeTh5AnWwdkC0H1sBAheyIB1I82CqVNIKn6YZjCw25EESUEg29Q261xLKY+SA30TTUvvTL9r
UWpndUTmqjULbL83rq4EdNYOCe+VHdPAoiOgtpZSAyShHXrlh32rZwBVdppnAscL8jbnHiEe
VCCzKgA6tfVA+t1CJtt1l0AQVwo3OI2XDodO24ezVBkqqjUAiy36QLMz5+i6mBvRu7cXpArC
3qzL6mvg+PLaRT+3eLuYIRAOY2ZSfPhlyrEQUHFVO/2ezsUfOek9yxYxnlg991imID3GC8sO
viLOMo8zGWUeCg21Ho2r4kSVIw1gG0sB8b+IxlRwRBUscEaxpr1ZYGFN4her88xu132gSztx
XUebokYBERrAxEsIYIGLQwADElSJBWTimZB7KEDNkcNMtJvC7Orwi9sySa7ythnZiOzmoR2z
tEjYfORvzXCj4tQW7cGWXHOB63kNsRsNNi+vJz1Ys3lIUEwdFnvXgPmKJ1gr0WJKaZCpVheq
b1a9aiR125W/v9dDTz42gVIzhdfC0KWB247axQIiLdY8AljMab7XDehwjqYMzxF7+2dI8tRa
AtlAZzG2yQuRYqcQSUBRBGZmNU0h0EGmv4/NMM/jnDgrJgGXaKHfsdZNfMx/z4SXC5nT3TuT
brPPrTd1FPrs9bVpeTIewZBlT5PGfZxkzfjwpn08uNiKfdzdQF+hvPzmABULaYjU+WAqlo//
CtbtBGKsJn+6Geg02nS/B1wEh9+g++qMvw/1eQUvH7IckdbS/5DvdF2sNW2WH6MsDrQ0CQCH
34oP5w8QUO7fDqbRb6s+EQfHc3L1mrF6XAXnL9PtuuFn3n4fVgYTbuU97B4IgXBMTL7R3f0S
53oXy0tPMfo2ZgEgEfvh3Pz/aDzk0JxSIt+VtaCr1d6gQJvLQOfqRj+zZalEKB7e5owPtMpV
1nn+xBv+rrSYjLWdQ+HFkFnOpsFWyUhZVdDF+qLgkAjRQBeziPHo8z0/cpetrW/LgLMv+eHm
FRek4rvCybkJslYRMSQXs9OUEgEX8NGAH8eKrevt54mbngQnoBcDMxB1tJWqA7GKVOJw0G6d
ND8lYVzcKCK/H7sbaHIUxr8n49nzQlZAaMXx9O63tt5e3HOGb1U0G63GNMhc157X2xhOoJAI
cuvzUG5wfzDQkAjrWx8vbapJ0M32+UXhJGLIE3BEgEk3IEk27Dc6fFwEgAgKUsBKDCbZ+Jwl
MmKDNnAi1kSb4rRbOLoLS6yWz9aj3jTyn0xYxnqZJQNxmw/qy1yAZliwMvEwPgP5Fh3PxDv1
ViQCKlw3KhsuFHuLuSKcKEgC3H8IgA==

--XsQoSWH+UP9D9v3l--
